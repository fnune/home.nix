return {
  {
    "folke/which-key.nvim",
    config = function()
      local constants = require("constants")
      local wk = require("which-key")

      wk.setup({
        win = { border = constants.floating_border, padding = { 0, 0, 0, 0 } },
        icons = { mappings = false },
      })

      wk.add({
        { "<leader>a", group = "Code actions" },
        { "<leader>d", group = "Debugging" },
        { "<leader>h", group = "Repository history" },
        { "<leader>m", group = "Global marks" },
        { "<leader>s", group = "Search" },
        { "<leader>t", group = "Tests" },
        { "<leader>tu", group = "Run with --snapshot-update" },
        { "g", group = "Go to" },
      })
    end,
  },
}