return {
  { "tpope/vim-abolish" },
  {
    "markonm/traces.vim",
    version = false,
    init = function()
      vim.g.traces_abolish_integration = 1
    end,
  },
}
