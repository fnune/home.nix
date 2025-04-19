local highlights = require("highlights")
return {
  {
    "rachartier/tiny-devicons-auto-colors.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    event = "VeryLazy",
    config = function()
      local colors = {}
      for _, color in pairs(highlights.get_palette()) do
        table.insert(colors, color)
      end
      local auto_colors = require("tiny-devicons-auto-colors")
      auto_colors.setup({ colors = colors })
    end,
  },
  highlights.make_theme({
    name = "standard",
    version = false,
    repo = "fnune/standard",
    palette = function()
      return require("standard.palette").tokens
    end,
  }),
}
