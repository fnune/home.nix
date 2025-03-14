local M = {}

M.hide_end_of_buffer_characters = function()
  vim.cmd([[hi EndOfBuffer guifg=bg guibg=bg]])
end

M.highlight_italics = function()
  local groups = {
    "@comment",
    "@conditional",
    "@exception",
    "@include",
    "@keyword",
    "@keyword.function",
    "@keyword.operator",
    "@repeat",
    "Comment",
    "Conditional",
    "Exception",
    "Include",
    "Keyword",
    "Repeat",
    "SpecialComment",
  }

  local function set_italic_safe(group)
    local success, hl_info = pcall(vim.api.nvim_exec, string.format("highlight %s", group), true)
    if success and not hl_info:find("links to") then
      local gui = hl_info:match("gui=(%S+)") -- Assume termguicolors, no need for cterm
      if not gui or not gui:find("italic") then
        gui = gui and gui .. ",italic" or "italic"
        vim.cmd(string.format("highlight %s gui=%s", group, gui))
      end
    end
  end

  for _, group in ipairs(groups) do
    set_italic_safe(group)
  end
end

M.apply_common_highlights = function()
  vim.opt.termguicolors = true
  M.highlight_italics()
  M.hide_end_of_buffer_characters()
end

M.make_theme = function(opts)
  local enabled = os.getenv("COLORSCHEME") == opts.name
  return {
    opts.repo,
    name = opts.name,
    version = opts.version,
    branch = opts.branch,
    lazy = not enabled,
    priority = 1000,
    dev = opts.dev or false,
    dir = opts.dir,
    config = function(plugin)
      if opts.config then
        opts.config(plugin)
      end

      vim.g.ThemePalette = opts.palette or function()
        return {}
      end

      if enabled then
        vim.cmd.colorscheme(opts.colorscheme or opts.name)
      end

      M.apply_common_highlights()
    end,
  }
end

M.get_palette = function()
  return vim.g.ThemePalette()
end

return M
