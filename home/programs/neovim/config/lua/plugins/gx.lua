return {
  "chrishrb/gx.nvim",
  cmd = { "Browse" },
  dependencies = { "nvim-lua/plenary.nvim" },
  config = true,
  init = function()
    vim.g.netrw_nogx = 1
  end,
  keys = {
    { "gx", ":Browse<CR>", mode = { "n", "x" }, desc = "Browse", silent = true },
  },
}
