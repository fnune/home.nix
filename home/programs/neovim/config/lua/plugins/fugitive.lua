return {
  "tpope/vim-fugitive",
  lazy = true,
  cmd = { "Git" },
  init = function()
    vim.cmd([[let $GIT_CONFIG_PARAMETERS = "'blame.date=short'"]])
  end,
  keys = {
    { "<leader>hb", ":Git blame<cr>", desc = "Open git blame view", silent = true },
  },
}
