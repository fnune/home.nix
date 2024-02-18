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
    init = function()
      local m = require("mapx")

      m.nmap("<leader>e", ":NvimTreeToggle<cr>", { silent = true }, "Toggle the file explorer view")
      m.nmap("<leader>E", ":NvimTreeFindFile<cr>", { silent = true }, "Find the current file in the explorer")
    end,
  },
  {
    "antosha417/nvim-lsp-file-operations",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-tree.lua",
    },
    enable = false,
    config = function()
      require("lsp-file-operations").setup()
    end,
  },
}
