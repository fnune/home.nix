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
  },
  init = function()
    -- See https://github.com/sindrets/diffview.nvim/issues/196#issuecomment-1244133866
    vim.cmd([[
      function DiffviewOpenCommitUnderCursor()
        exe 'norm! 0"xyiw' | wincmd l | exe 'DiffviewOpen ' . getreg("x") . '^!'
      endfunction

      function DiffviewFileHistoryFromCommitUnderCursor()
        exe 'norm! 0"xyiw' | wincmd l | exe 'DiffviewFileHistory % --range=' . getreg("x")
      endfunction
    ]])
  end,
  keys = {
    { "<leader>hq", ":DiffviewClose<cr>", desc = "Close diff view", silent = true },
    { "<leader>hh", ":DiffviewFileHistory %<cr>", desc = "File history", silent = true },
    {
      "<leader>hO",
      ":call DiffviewOpenCommitUnderCursor()<cr>",
      desc = "Diff for the commit under the cursor",
      silent = true,
    },
    {
      "<leader>hH",
      ":call DiffviewFileHistoryFromCommitUnderCursor()<cr>",
      desc = "File history starting from the commit under the cursor",
      silent = true,
    },
  },
}
