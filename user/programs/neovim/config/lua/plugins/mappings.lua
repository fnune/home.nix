local constants = require("constants")
return {
  {
    "b0o/mapx.nvim",
    priority = 51,
    opts = { whichkey = false },
  },
  {
    "folke/which-key.nvim",
    enabled = false,
    opts = {
      window = { border = constants.floating_border, padding = { 0, 0, 0, 0 } },
    },
  },
}
