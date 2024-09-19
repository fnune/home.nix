return {
  "Bekaboo/dropbar.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons", "nvim-telescope/telescope-fzf-native.nvim" },
  config = function()
    local dropbar = require("dropbar")
    dropbar.setup({})
  end,
  init = function()
    local dropbar_api = require("dropbar.api")

    local m = require("mapx")
    m.nmap("<leader>B", function()
      dropbar_api.pick()
    end, "Navigate breadcrumbs")
  end,
}
