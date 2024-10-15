local constants = require("constants")
return {
  "NeogitOrg/neogit",
  event = "VeryLazy",
  dependencies = { "nvim-lua/plenary.nvim" },
  opts = {
    disable_commit_confirmation = true,
    disable_hint = true,
    kind = "auto",
    graph_style = "unicode",
    sections = { recent = { folded = false } },
    status = { recent_commit_count = 99 },
    signs = {
      hunk = { "", "" },
      item = { constants.signs.caret_right, constants.signs.caret_down },
      section = { constants.signs.caret_right, constants.signs.caret_down },
    },
    integrations = {
      telescope = true,
      diffview = true,
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
    { "<leader>g", ":Neogit<cr>", desc = "Open neogit", silent = true },
  },
}
