local constants = require("constants")
return {
  "Yu-Leo/blame-column.nvim",
  cmd = "BlameColumnToggle",
  opts = {
    time_based_bg_opts = {
      hue = 75,
      lightness_min = 0,
      lightness_max = 30,
    },
    commit_info = {
      window_opts = {
        border = constants.floating_border,
      },
    },
  },
  keys = {
    {
      "<leader>hb",
      function()
        require("blame-column").toggle()
      end,
      desc = "Open git blame view",
      silent = true,
    },
  },
}
