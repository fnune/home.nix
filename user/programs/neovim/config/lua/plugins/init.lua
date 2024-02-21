return {
  -- low-level fixes and utilities
  { "LunarVim/bigfile.nvim" },
  { "antoinemadec/FixCursorHold.nvim" },
  { "b0o/SchemaStore.nvim" },
  { "folke/neodev.nvim", opts = { library = { plugins = { "neotest" }, types = true } }, priority = 51 },
  { "nvim-lua/plenary.nvim", priority = 51 },
  -- LSP & UI
  { "brenoprata10/nvim-highlight-colors", opts = { enable_tailwind = true } },
  { "folke/todo-comments.nvim", config = true },
  { "folke/trouble.nvim" },
  { "mbbill/undotree" },
  { "nvim-tree/nvim-web-devicons" },
}
