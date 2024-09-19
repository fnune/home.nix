return {
  "chrishrb/gx.nvim",
  cmd = { "Browse" },
  dependencies = { "nvim-lua/plenary.nvim" },
  config = true,
  init = function()
    vim.g.netrw_nogx = 1

    local m = require("mapx")
    m.nmap("gx", ":Browse<CR>", { silent = true }, "Browse")
    m.xmap("gx", ":Browse<CR>", { silent = true }, "Browse")
  end,
}
