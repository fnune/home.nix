return {
  "rmagatti/auto-session",
  lazy = false,
  init = function()
    vim.opt.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"
  end,
  opts = {},
}
