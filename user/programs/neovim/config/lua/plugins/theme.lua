function HideEndOfBufferCharacters()
  vim.cmd([[hi EndOfBuffer guifg=bg guibg=bg]])
end

function HighlightItalics()
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

function ApplyCommonHighlights()
  vim.opt.termguicolors = true
  HighlightItalics()
  HideEndOfBufferCharacters()
end

return {
  { "nvim-treesitter/playground" },
  {
    "levouh/tint.nvim",
    opts = {
      highlight_ignore_patterns = {
        "DapUI*",
        "EndOfBuffer",
        "VertSplit",
        "WinSeparator",
      },
    },
  },
  {
    "Mofiqul/vscode.nvim",
    enabled = os.getenv("COLORSCHEME") == "vscode",
    priority = 1000,
    lazy = false,
    config = function()
      local colors = require("vscode.colors").get_colors()
      local vscode = require("vscode")

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
          ["ScrollView"] = { bg = colors.vscLeftMid },
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

      ApplyCommonHighlights()
    end,
  },
}
