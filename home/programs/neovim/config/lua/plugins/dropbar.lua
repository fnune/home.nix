return {
  "Bekaboo/dropbar.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    local dropbar = require("dropbar")
    dropbar.setup({})
  end,
}
