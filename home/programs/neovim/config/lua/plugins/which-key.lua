return {
  {
    "folke/which-key.nvim",
    config = function()
      local constants = require("constants")
      local wk = require("which-key")

      wk.setup({
        window = { border = constants.floating_border, padding = { 0, 0, 0, 0 } },
      })

      wk.register({
        ["<leader>a"] = { name = "Code actions" },
        ["<leader>d"] = { name = "Debugging" },
        ["<leader>h"] = { name = "Repository history" },
        ["<leader>m"] = { name = "Global marks" },
        ["<leader>s"] = { name = "Search" },
        ["<leader>t"] = { name = "Tests" },
        ["<leader>tu"] = { name = "Run with --snapshot-update" },
        ["g"] = { name = "Go to" },
      })
    end,
  },
}
