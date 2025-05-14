local constants = require("constants")
return {
  "rgroli/other.nvim",
  config = function()
    require("other-nvim").setup({
      mappings = {
        "angular",
        "golang",
        "python",
        "react",
      },
      style = { border = constants.floating_border },
    })
  end,
  keys = {
    {
      "<leader>O",
      ":Other<CR>",
      desc = "Open alternative file",
    },
  },
}
