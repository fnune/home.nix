local function HideEndOfBufferCharacters()
  vim.cmd([[hi EndOfBuffer guifg=bg guibg=bg]])
end

local function HighlightItalics()
  local groups = {
    "@comment",
    "@conditional",
    "@exception",
    "@include",
    "@keyword",
    "@keyword.function",
    "@keyword.operator",
    "@repeat",
    "Comment",
    "Conditional",
    "Exception",
    "Include",
    "Keyword",
    "Repeat",
    "SpecialComment",
  }

  local function set_italic_safe(group)
    local success, hl_info = pcall(vim.api.nvim_exec, string.format("highlight %s", group), true)
    if success and not hl_info:find("links to") then
      local gui = hl_info:match("gui=(%S+)") -- Assume termguicolors, no need for cterm
      if not gui or not gui:find("italic") then
        gui = gui and gui .. ",italic" or "italic"
        vim.cmd(string.format("highlight %s gui=%s", group, gui))
      end
    end
  end

  for _, group in ipairs(groups) do
    set_italic_safe(group)
  end
end

local function ApplyCommonHighlights()
  vim.opt.termguicolors = true
  HighlightItalics()
  HideEndOfBufferCharacters()
end

return {
  {
    "Mofiqul/vscode.nvim",
    enabled = os.getenv("COLORSCHEME") == "vscode",
    priority = 1000,
    lazy = false,
    config = function()
      local colors = require("vscode.colors").get_colors()
      local vscode = require("vscode")

      vim.g.ThemePalette = function()
        return colors
      end

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
          -- Borders
          ["FloatBorder"] = { fg = colors.vscLeftDark },
          ["TelescopePreviewBorder"] = { fg = colors.vscLeftDark },
          ["TelescopePromptBorder"] = { fg = colors.vscLeftDark },
          ["TelescopeResultsBorder"] = { fg = colors.vscLeftDark },
          ["VertSplit"] = { fg = colors.vscLeftDark },
          -- Scrollbars
          ["PmenuSbar"] = { bg = colors.vscBack },
          ["PmenuThumb"] = { fg = colors.vscLeftMid, bg = colors.vscLeftMid },
          -- Fixes
          ["NeogitWinSeparator"] = { link = "WinSeparator" },
          ["DropBarIconUIPickPivot"] = { link = "@comment.note" },
        },
      })

      vscode.load()

      ApplyCommonHighlights()
    end,
  },
  {
    "rose-pine/neovim",
    name = "rose-pine",
    enabled = os.getenv("COLORSCHEME") == "rose-pine",
    lazy = false,
    priority = 1000,
    opts = { disable_italics = true, disable_float_background = true },
    init = function()
      vim.cmd.colorscheme("rose-pine")

      vim.g.ThemePalette = function()
        return require("rose-pine.palette")
      end

      ApplyCommonHighlights()
    end,
  },
  {
    "rachartier/tiny-devicons-auto-colors.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons", "Mofiqul/vscode.nvim" },
    event = "VeryLazy",
    config = function()
      local auto_colors = require("tiny-devicons-auto-colors")
      auto_colors.setup({ colors = vim.g.ThemePalette() })
    end,
  },
}
