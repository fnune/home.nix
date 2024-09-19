local constants = require("constants")
return {
  "petertriho/nvim-scrollbar",
  dependencies = { "lewis6991/gitsigns.nvim" },
  opts = {
    set_highlights = true,
    handle = { highlight = "StatusLine" },
    handlers = { cursor = false, gitsigns = true },
    marks = {
      Error = { text = { constants.signs.error_single } },
      Warn = { text = { constants.signs.warn_single } },
      Info = { text = { constants.signs.info_single } },
      Hint = { text = { constants.signs.hint_single } },
      GitAdd = { text = "┃" },
      GitChange = { text = "┃" },
      GitDelete = { text = "_" },
    },
  },
}
