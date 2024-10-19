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
    repo = "Mofiqul/vscode.nvim",
    palette = function()
      return require("vscode.colors").get_colors()
    end,
    config = function()
      local vscode = require("vscode")
      local colors = require("vscode.colors").get_colors()
      vscode.setup({
        disable_nvimtree_bg = true,
        underline_links = true,
        group_overrides = {
          ["@comment"] = { fg = colors.vscGray },
          ["Comment"] = { fg = colors.vscGray },
          ["NormalFloat"] = { bg = colors.vscBack },
          ["Pmenu"] = { fg = colors.vscPopupFront, bg = "NONE" },
          ["PmenuSel"] = { fg = "NONE", bg = colors.vscPopupHighlightBlue },
          ["SpecialComment"] = { fg = colors.vscGray },
          ["FloatBorder"] = { fg = colors.vscLeftDark },
          ["TelescopePreviewBorder"] = { fg = colors.vscLeftDark },
          ["TelescopePromptBorder"] = { fg = colors.vscLeftDark },
          ["TelescopeResultsBorder"] = { fg = colors.vscLeftDark },
          ["VertSplit"] = { fg = colors.vscLeftDark },
          ["PmenuSbar"] = { bg = colors.vscBack },
          ["PmenuThumb"] = { fg = colors.vscLeftMid, bg = colors.vscLeftMid },
          ["NeogitWinSeparator"] = { link = "WinSeparator" },
          ["DropBarIconUIPickPivot"] = { link = "@comment.note" },
        },
      })
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
}
