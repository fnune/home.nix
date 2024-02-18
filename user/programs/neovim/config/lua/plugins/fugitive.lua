return {
  "tpope/vim-fugitive",
  lazy = true,
  cmd = { "Git" },
  init = function()
    vim.cmd([[let $GIT_CONFIG_PARAMETERS = "'blame.date=short'"]])

    local m = require("mapx")
    m.nmap("<leader>Db", ":Git blame<cr>", { silent = true }, "Open git blame view")
  end,
}
