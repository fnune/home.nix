local constants = require("constants")
return {
  "sindrets/diffview.nvim",
  lazy = true,
  cmd = { "DiffviewOpen", "DiffviewFileHistory" },
  opts = {
    enhanced_diff_hl = true,
    use_icons = true,
    file_panel = {
      win_config = {
        width = constants.file_explorer_width_chars,
      },
    },
    hooks = {
      diff_buf_win_enter = function(_, winid, _)
        -- Turn off cursor line for diffview windows because of bg conflict
        -- https://github.com/neovim/neovim/issues/9800
        vim.wo[winid].culopt = "number"
      end,
    },
  },
  keys = {
    { "<leader>hq", ":DiffviewClose<cr>", desc = "Close diff view", silent = true },
    { "<leader>hh", ":DiffviewFileHistory %<cr>", desc = "File history", silent = true },
  },
}
