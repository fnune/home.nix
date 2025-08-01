local constants = require("constants")
return {
  "NeogitOrg/neogit",
  version = false,
  event = "VeryLazy",
  dependencies = { "nvim-lua/plenary.nvim" },
  opts = {
    disable_hint = true,
    kind = "auto",
    graph_style = "unicode",
    sections = { recent = { folded = false } },
    status = { recent_commit_count = 99 },
    auto_show_console_on = "error",
    initial_branch_name = "fnune/",
    signs = {
      hunk = { "", "" },
      item = { constants.signs.caret_right, constants.signs.caret_down },
      section = { constants.signs.caret_right, constants.signs.caret_down },
    },
    ignored_settings = {
      "NeogitCommitPopup--allow-empty",
      "NeogitCommitPopup--no-edit",
      "NeogitCommitPopup--no-verify",
      "NeogitPullPopup--rebase",
      "NeogitPushPopup--force",
      "NeogitPushPopup--force-with-lease",
    },
  },
  keys = {
    { "<leader>g", vim.cmd.Neogit, desc = "Open neogit", silent = true },
  },
}
