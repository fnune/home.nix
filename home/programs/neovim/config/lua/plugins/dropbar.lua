return {
  "Bekaboo/dropbar.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons", "nvim-telescope/telescope-fzf-native.nvim" },
  config = function()
    local dropbar = require("dropbar")
    dropbar.setup({})
  end,
}
