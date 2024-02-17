local constants = require("constants")
return {
  {
    "b0o/mapx.nvim",
    priority = 51,
    opts = { whichkey = true },
  },
  {
    "folke/which-key.nvim",
    opts = {
      window = { border = constants.floating_border, padding = { 0, 0, 0, 0 } },
    },
  },
}
