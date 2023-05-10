return {
  "windwp/nvim-ts-autotag",
  "antoinemadec/FixCursorHold.nvim",
  "christoomey/vim-tmux-navigator",
  { "folke/which-key.nvim",         opts = { window = { border = "single", padding = { 0, 0, 0, 0 } } } },
  "machakann/vim-swap",
  "matze/vim-move",
  "mbbill/undotree",
  "nvim-tree/nvim-web-devicons",
  "tpope/vim-abolish",
  "tpope/vim-commentary",
  "tpope/vim-dadbod",
  "tpope/vim-eunuch",
  "tpope/vim-repeat",
  "tpope/vim-rhubarb",
  "tpope/vim-surround",
  {
    "b0o/mapx.nvim",
    priority = 51,
    opts = {
      whichkey = true }
  },
  { "kevinhwang91/nvim-bqf",        lazy = true,                                                        ft = "qf" },
  { "kristijanhusak/vim-dadbod-ui", lazy = true,                                                        cmd = "DBUI" },
  { "lewis6991/gitsigns.nvim",      config = true },
  { "nvim-lua/plenary.nvim",        priority = 51 },
  { "tversteeg/registers.nvim",     lazy = true },
}
