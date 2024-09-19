return {
  "stevearc/aerial.nvim",
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "nvim-tree/nvim-web-devicons",
  },
  config = function()
    local m = require("mapx")
    m.nmap("<leader>T", "<cmd>AerialToggle!<cr>", "Code outline window")

    local constants = require("constants")
    local aerial = require("aerial")
    aerial.setup({
      layout = { min_width = constants.file_explorer_width_chars },
      filter_kind = false,
    })
  end,
}
