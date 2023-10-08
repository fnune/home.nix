return {
  "NeogitOrg/neogit",
  lazy = true,
  cmd = "Neogit",
  opts = {
    disable_commit_confirmation = true,
    disable_builtin_notifications = true,
    kind = "vsplit",
    integrations = {
      telescope = true,
      diffview = true,
    },
    ignored_settings = {
      "NeogitCommitPopup--allow-empty",
      "NeogitPullPopup--rebase",
      "NeogitPushPopup--force",
      "NeogitPushPopup--force-with-lease",
      "NeogitRevertPopup--no-edit",
      "NeogitRevertPopup--no-verify",
    },
  },
  init = function()
    local m = require("mapx")

    m.nmap("<leader>g", ":Neogit<cr>", { silent = true }, "Open neogit")
  end,
}
