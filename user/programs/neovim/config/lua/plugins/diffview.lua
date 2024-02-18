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
    local m = require("mapx")

    m.nname("<leader>h", "Repository history")
    m.nmap("<leader>hq", ":DiffviewClose<cr>", { silent = true }, "Close diff view")
    m.nmap("<leader>hh", ":DiffviewFileHistory<cr>", { silent = true }, "File history")
    m.nmap(
      "<leader>hO",
      ":call DiffviewOpenCommitUnderCursor()<cr>",
      { silent = true },
      "Diff for the commit under the cursor"
    )
    m.nmap(
      "<leader>hH",
      ":call DiffviewFileHistoryFromCommitUnderCursor()<cr>",
      { silent = true },
      "File history starting from the commit under the cursor"
    )

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
}
