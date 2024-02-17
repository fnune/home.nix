local Job = require("plenary.job")

local current = "Loading..."

local watson_working_fg = vim.fn.synIDattr(vim.fn.hlID("DiagnosticOk"), "fg#")
vim.cmd(string.format("highlight WatsonWorking guibg=#262626 guifg=%s gui=italic", watson_working_fg))

local watson_no_project_fg = vim.fn.synIDattr(vim.fn.hlID("Comment"), "fg#")
vim.cmd(string.format("highlight WatsonNoProject guibg=#262626 guifg=%s gui=italic", watson_no_project_fg))

local function set_current_status(output)
  if output:find("^Project") then
    current = "%#WatsonWorking#" .. output:gsub("Project", "Clock"):gsub("%(%d%d%d%d%..-%+.-%)", "")
  elseif output:find("^No project") then
    current = "%#WatsonNoProject#No clock started"
  else
    current = output
  end
end

local function update_watson_status()
  Job:new({
    command = "watson",
    args = { "status" },
    on_exit = function(handle, _)
      local output = table.concat(handle:result(), " ")
      set_current_status(output)
    end,
  }):start()
end

local function start_project()
  local project = vim.fn.input({ prompt = "Start working on: " })
  vim.cmd("redraw")
  if project ~= "" then
    local output = vim.fn.system(string.format('watson start "%s"', project))
    local output_first_line = string.match(output, "^[^\n]*")
    vim.cmd(string.format('echo "%s"', output_first_line))
    update_watson_status()
  end
end

local function stop_project()
  vim.fn.system("watson stop")
  update_watson_status()
end

local m = require("mapx")
m.nname("<leader>w", "Time tracking")
m.nmap("<leader>wi", start_project, { silent = true }, "Start a timer")
m.nmap("<leader>wo", stop_project, { silent = true }, "Stop the current timer")

update_watson_status()

return {
  WatsonStatus = function()
    update_watson_status()
    return current
  end,
}
