return {
  "Yu-Leo/blame-column.nvim",
  cmd = "BlameColumnToggle",
  opts = {
    time_based_bg_opts = {
      hue = 75,
      lightness_min = 0,
      lightness_max = 30,
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
