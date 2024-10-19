local highlights = require("highlights")

local function make_theme(config)
  local enabled = os.getenv("COLORSCHEME") == config.name
  return {
    config.repo,
    name = config.name,
    lazy = not enabled,
    priority = 1000,
    config = function()
      if config.setup then
        config.setup()
      end

      vim.g.ThemePalette = config.palette or function()
        return {}
      end

      if enabled then
        vim.cmd.colorscheme(config.colorscheme or config.name)
      end

      highlights.apply_common_highlights()
    end,
  }
end

return {
  {
    "rachartier/tiny-devicons-auto-colors.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    event = "VeryLazy",
    config = function()
      local auto_colors = require("tiny-devicons-auto-colors")
      auto_colors.setup({ colors = vim.g.ThemePalette() })
    end,
  },
  make_theme({
    name = "vscode",
    repo = "Mofiqul/vscode.nvim",
    palette = function()
      return require("vscode.colors").get_colors()
    end,
    setup = function()
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
  make_theme({
    name = "rose-pine",
    repo = "rose-pine/neovim",
    palette = function()
      return require("rose-pine.palette")
    end,
  }),
}
