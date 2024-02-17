return {
  "Shatur/neovim-session-manager",
  config = function()
    local config = require("session_manager.config")
    local session_manager = require("session_manager")

    session_manager.setup({
      autoload_mode = config.AutoloadMode.CurrentDir,
      autosave_ignore_not_normal = false, -- Save the session even if it's empty
    })
  end,
}
