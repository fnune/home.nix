local constants = require("constants")
return {
  {
    "b0o/mapx.nvim",
    priority = 51,
    opts = { whichkey = true },
  },
  {
    "folke/which-key.nvim",
    tag = "v2.1.0", -- v3 schema is incompatible with mapx
    opts = {
      win = { border = constants.floating_border, padding = { 0, 0, 0, 0 } },
    },
  },
}
