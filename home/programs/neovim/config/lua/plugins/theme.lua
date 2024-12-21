local highlights = require("highlights")
return {
  {
    "rachartier/tiny-devicons-auto-colors.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    event = "VeryLazy",
    config = function()
      local auto_colors = require("tiny-devicons-auto-colors")
      auto_colors.setup({ colors = highlights.get_palette() })
    end,
  },
  highlights.make_theme({
    name = "vscode",
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
    repo = "fnune/standard",
    dev = true,
    palette = function()
      return require("standard.palette").tokens
    end,
  }),
}
