return {
  { "tpope/vim-abolish" },
  {
    "markonm/traces.vim",
    init = function()
      vim.g.traces_abolish_integration = 1
    end,
  },
}
