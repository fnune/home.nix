local M = {}

---@type table<integer, table>
local states = {}

local config = {
  outline_width = 30,
  ns_name = "mdread",
}

local function usable_width(win)
  local total = vim.api.nvim_win_get_width(win)
  local info = vim.fn.getwininfo(win)[1]
  local off = (info and info.textoff) or 0
  return math.max(20, total - off)
end

local function build_outline(source_buf)
  local headings = {}
  local ok, parser = pcall(vim.treesitter.get_parser, source_buf, "markdown")
  if not ok or not parser then return headings end

  local trees = parser:parse()
  if not trees or #trees == 0 then return headings end
  local root = trees[1]:root()

  local ok_q, query = pcall(vim.treesitter.query.parse, "markdown", [[
    (atx_heading) @h
    (setext_heading) @h
  ]])
  if not ok_q then return headings end

  for _, node in query:iter_captures(root, source_buf) do
    local start_row = node:range()
    local text = vim.treesitter.get_node_text(node, source_buf)
    if type(text) == "string" then
      local first_line = text:match("^([^\n]*)") or text
      local level, name
      local hashes, rest = first_line:match("^(#+)%s*(.*)$")
      if hashes then
        level = #hashes
        name = (rest or ""):gsub("%s+$", "")
      else
        local nl = text:find("\n")
        if nl then
          local underline_char = text:sub(nl + 1, nl + 1)
          level = (underline_char == "=") and 1 or 2
          name = first_line:gsub("^%s+", ""):gsub("%s+$", "")
        end
      end
      if name and name ~= "" then
        table.insert(headings, { level = level or 1, name = name, lnum = start_row + 1 })
      end
    end
  end

  table.sort(headings, function(a, b) return a.lnum < b.lnum end)
  return headings
end

local function populate_outline(buf, headings)
  local lines = {}
  if #headings == 0 then
    lines = { "(no headings)" }
  else
    for _, h in ipairs(headings) do
      local indent = string.rep("  ", math.max(0, h.level - 1))
      table.insert(lines, indent .. h.name)
    end
  end
  vim.bo[buf].modifiable = true
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
  vim.bo[buf].modifiable = false
  vim.bo[buf].readonly = true
end

local function create_session(source_buf, max_width)
  local ok, mdr = pcall(require, "md-render")
  if not ok then
    vim.notify("mdread: md-render is required", vim.log.levels.ERROR)
    return nil
  end
  local Session = mdr.preview and mdr.preview._Session
  if not Session then
    vim.notify("mdread: md-render's _Session is not exposed", vim.log.levels.ERROR)
    return nil
  end
  return Session.new(source_buf, config.ns_name, {
    max_width = max_width,
    indent = "  ",
  })
end

local function configure_outline_win(win, buf)
  vim.bo[buf].buftype = "nofile"
  vim.bo[buf].bufhidden = "wipe"
  vim.bo[buf].swapfile = false
  vim.bo[buf].filetype = "mdread-outline"
  vim.wo[win].number = false
  vim.wo[win].relativenumber = false
  vim.wo[win].signcolumn = "no"
  vim.wo[win].cursorline = true
  vim.wo[win].wrap = false
  vim.wo[win].winfixwidth = true
  vim.wo[win].winbar = " Outline"
end

local function configure_read_win(win)
  vim.wo[win].number = false
  vim.wo[win].relativenumber = false
  vim.wo[win].signcolumn = "no"
  vim.wo[win].cursorline = false
  vim.wo[win].wrap = false
  vim.wo[win].winbar = " Reading"
end

local function find_state_for_buf(buf)
  if states[buf] then return buf, states[buf] end
  for sb, s in pairs(states) do
    if s.render_buf == buf or s.outline_buf == buf then
      return sb, s
    end
  end
  return nil, nil
end

function M.enter()
  local source_buf = vim.api.nvim_get_current_buf()
  local source_win = vim.api.nvim_get_current_win()

  if vim.bo[source_buf].filetype ~= "markdown" then
    vim.notify("mdread: not a markdown buffer", vim.log.levels.WARN)
    return
  end

  if states[source_buf] then return end

  local source_cursor = vim.api.nvim_win_get_cursor(source_win)[1]
  local source_view = vim.fn.winsaveview()

  pcall(function()
    local aerial = require("aerial")
    if aerial.is_open() then aerial.close() end
  end)

  vim.cmd(string.format("noautocmd topleft %dvsplit", config.outline_width))
  local outline_win = vim.api.nvim_get_current_win()
  local outline_buf = vim.api.nvim_create_buf(false, true)
  pcall(vim.api.nvim_buf_set_name, outline_buf, "mdread://outline/" .. source_buf)
  vim.api.nvim_win_set_buf(outline_win, outline_buf)
  configure_outline_win(outline_win, outline_buf)

  vim.api.nvim_set_current_win(source_win)

  local width = usable_width(source_win)
  local session = create_session(source_buf, width)
  if not session then
    pcall(vim.api.nvim_win_close, outline_win, true)
    return
  end

  vim.api.nvim_win_set_buf(source_win, session.buf)
  session:bind_window(source_win)
  configure_read_win(source_win)

  pcall(function() session:install_float_keymaps(nil, { close_keys = {} }) end)

  local headings = build_outline(source_buf)
  populate_outline(outline_buf, headings)

  pcall(function() session:scroll_to_source_line(source_cursor) end)

  local augroup = vim.api.nvim_create_augroup("mdread_" .. source_buf, { clear = true })
  states[source_buf] = {
    source_buf = source_buf,
    source_win = source_win,
    session = session,
    render_buf = session.buf,
    outline_win = outline_win,
    outline_buf = outline_buf,
    headings = headings,
    width = width,
    source_view = source_view,
    augroup = augroup,
  }

  vim.keymap.set("n", "<CR>", function() M.jump_from_outline(source_buf) end,
    { buffer = outline_buf, desc = "mdread: jump to heading", silent = true })
  vim.keymap.set("n", "<2-LeftMouse>", function() M.jump_from_outline(source_buf) end,
    { buffer = outline_buf, desc = "mdread: jump to heading", silent = true })
  vim.keymap.set("n", "q", function() M.exit(source_buf) end,
    { buffer = outline_buf, desc = "mdread: exit", silent = true })
  vim.keymap.set("n", "q", function() M.exit(source_buf) end,
    { buffer = session.buf, desc = "mdread: exit", silent = true })

  vim.api.nvim_create_autocmd({ "VimResized", "WinResized" }, {
    group = augroup,
    callback = function() M.on_resize(source_buf) end,
  })
  vim.api.nvim_create_autocmd("BufWipeout", {
    group = augroup,
    buffer = source_buf,
    callback = function() M.cleanup(source_buf) end,
  })
  vim.api.nvim_create_autocmd("WinClosed", {
    group = augroup,
    callback = function(args)
      local closed_win = tonumber(args.match)
      local state = states[source_buf]
      if not state then return end
      if closed_win == state.outline_win or closed_win == state.source_win then
        vim.schedule(function() M.exit(source_buf) end)
      end
    end,
  })
end

function M.exit(source_buf)
  local cur_buf = source_buf or vim.api.nvim_get_current_buf()
  local key, state = find_state_for_buf(cur_buf)
  if not state then return end
  states[key] = nil

  pcall(vim.api.nvim_del_augroup_by_id, state.augroup)

  if state.outline_win and vim.api.nvim_win_is_valid(state.outline_win) then
    pcall(vim.api.nvim_win_close, state.outline_win, true)
  end
  if state.outline_buf and vim.api.nvim_buf_is_valid(state.outline_buf) then
    pcall(vim.api.nvim_buf_delete, state.outline_buf, { force = true })
  end

  if state.source_win and vim.api.nvim_win_is_valid(state.source_win)
      and vim.api.nvim_buf_is_valid(state.source_buf) then
    vim.api.nvim_win_set_buf(state.source_win, state.source_buf)
    vim.api.nvim_set_current_win(state.source_win)
    if state.source_view then
      pcall(vim.api.nvim_win_call, state.source_win, function()
        vim.fn.winrestview(state.source_view)
      end)
    end
  end

  if state.session then
    pcall(function() state.session:cleanup_images() end)
  end
  if state.render_buf and vim.api.nvim_buf_is_valid(state.render_buf) then
    pcall(vim.api.nvim_buf_delete, state.render_buf, { force = true })
  end
end

function M.cleanup(source_buf)
  states[source_buf] = nil
end

function M.toggle()
  local cur_buf = vim.api.nvim_get_current_buf()
  local key, _ = find_state_for_buf(cur_buf)
  if key then
    M.exit(key)
  else
    M.enter()
  end
end

function M.on_resize(source_buf)
  local state = states[source_buf]
  if not state then return end
  if not state.source_win or not vim.api.nvim_win_is_valid(state.source_win) then return end

  local new_width = usable_width(state.source_win)
  if new_width == state.width then return end
  state.width = new_width
  state.session.opts.max_width = new_width
  state.session:refresh_source()
  state.session:rebuild()
  pcall(function() state.session:refresh_images() end)
end

function M.jump_from_outline(source_buf)
  local state = states[source_buf]
  if not state then return end

  local index = vim.api.nvim_win_get_cursor(0)[1]
  local heading = state.headings[index]
  if not heading then return end

  if not state.source_win or not vim.api.nvim_win_is_valid(state.source_win) then return end

  local render_line = state.session:source_to_rendered(heading.lnum)
  local total = vim.api.nvim_buf_line_count(state.render_buf)
  render_line = math.max(1, math.min(render_line, total))

  vim.api.nvim_set_current_win(state.source_win)
  vim.api.nvim_win_set_cursor(state.source_win, { render_line, 0 })
  vim.cmd("normal! zt")
end

function M.setup(opts)
  opts = opts or {}
  if opts.outline_width then config.outline_width = opts.outline_width end
end

return M
