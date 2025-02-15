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
    name = "vscode",
    version = false,
    repo = "fnune/vscode.fnune.nvim",
    palette = function()
      return require("vscode.colors").get_colors()
    end,
    config = function()
      local vscode = require("vscode")
      vscode.setup({ disable_nvimtree_bg = true })
      vscode.load()
    end,
  }),
  highlights.make_theme({
    name = "rose-pine",
    repo = "rose-pine/neovim",
    palette = function()
      return require("rose-pine.palette")
    end,
  }),
  highlights.make_theme({
    name = "standard",
    version = false,
    repo = "fnune/standard",
    palette = function()
      return require("standard.palette").tokens
    end,
  }),
}
