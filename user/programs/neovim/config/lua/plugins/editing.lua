return {
  { "backdround/improved-ft.nvim", opts = { use_default_mappings = true } },
  { "LunarVim/bigfile.nvim" },
  { "christoomey/vim-tmux-navigator" },
  { "machakann/vim-swap" },
  { "matze/vim-move" },
  { "tpope/vim-abolish" },
  { "markonm/traces.vim", init = function() vim.g.traces_abolish_integration = 1 end },
  { "tpope/vim-eunuch" },
  { "tpope/vim-repeat" },
  { "tpope/vim-surround" },
  { "windwp/nvim-ts-autotag" },
}
