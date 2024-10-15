return {
  "stevearc/aerial.nvim",
  event = "VeryLazy",
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "nvim-tree/nvim-web-devicons",
  },
  config = function()
    local constants = require("constants")
    local aerial = require("aerial")
    aerial.setup({
      layout = { min_width = constants.file_explorer_width_chars },
      filter_kind = false,
      attach_mode = "global",
    })
  end,
  keys = {
    { "<leader>T", "<cmd>AerialToggle!<cr>", desc = "Code outline window", silent = true },
  },
}
