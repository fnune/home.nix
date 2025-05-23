local constants = require("constants")
return {
  {
    "nvim-tree/nvim-tree.lua",
    lazy = true,
    cmd = { "NvimTreeToggle", "NvimTreeFindFile" },
    opts = {
      view = { width = constants.file_explorer_width_chars },
      diagnostics = { enable = false },
      renderer = { group_empty = true },
      disable_netrw = true,
    },
    keys = {
      { "<leader>e", ":NvimTreeToggle<cr>", desc = "Toggle the file explorer view", silent = true },
      { "<leader>E", ":NvimTreeFindFile<cr>", desc = "Find the current file in the explorer", silent = true },
    },
  },
  {
    "antosha417/nvim-lsp-file-operations",
    config = true,
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-tree.lua",
    },
  },
}
