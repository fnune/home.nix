return {
  "olimorris/codecompanion.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
  },
  cmd = { "CodeCompanion", "CodeCompanionChat", "CodeCompanionAction", "CodeCompanionCmd" },
  keys = {
    {
      "<leader>at",
      "<cmd>CodeCompanionChat Toggle<CR>",
      desc = "Toggle the AI chat",
      silent = true,
    },
  },
  opts = {
    strategies = {
      chat = {
        adapter = "anthropic",
      },
      inline = {
        adapter = "anthropic",
      },
    },
  },
}
