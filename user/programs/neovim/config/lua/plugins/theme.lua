function LinkNvimDapHighlights()
  vim.cmd([[
    hi! link DapUIPlayPauseNC DapUIPlayPause
    hi! link DapUIRestartNC DapUIRestart
    hi! link DapUIStepBackNC DapUIStepBack
    hi! link DapUIStepIntoNC DapUIStepInto
    hi! link DapUIStepOutNC DapUIStepOut
    hi! link DapUIStepOverNC DapUIStepOver
    hi! link DapUIStopNC DapUIStop

    hi! link DapUIPlayPause DiagnosticOk
    hi! link DapUIRestart DiagnosticOk
    hi! link DapUIStepBack Macro
    hi! link DapUIStepInto Macro
    hi! link DapUIStepOut Macro
    hi! link DapUIStepOver Macro
    hi! link DapUIStop DiagnosticError
    hi! link DapUIType Macro
    hi! link DapUIWinSelect DiagnosticHint
  ]])
end

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
  LinkNvimDapHighlights()
  HighlightItalics()
  HideEndOfBufferCharacters()
end

return {
  { "nvim-treesitter/playground" },
  {
    "rose-pine/neovim",
    name = "rose-pine",
    lazy = false,
    priority = 1000,
    opts = { disable_italics = true, disable_float_background = true },
    enabled = false,
    init = function()
      vim.cmd.colorscheme("rose-pine-moon")

      ApplyCommonHighlights()
    end,
  },
  {
    "Mofiqul/vscode.nvim",
    priority = 1000,
    lazy = false,
    enabled = true,
    config = function()
      local colors = require("vscode.colors").get_colors()
      local vscode = require("vscode")

      vscode.setup({
        disable_nvimtree_bg = true,
        group_overrides = {
          ["@comment"] = { fg = colors.vscGray },
          ["Comment"] = { fg = colors.vscGray },
          ["SpecialComment"] = { fg = colors.vscGray },
          ["Pmenu"] = { fg = colors.vscPopupFront, bg = "NONE" },
        },
      })

      vscode.load()

      local neogit_bg_fg = {
        { "NeogitDiffHeader", colors.vscBack, colors.vscSplitLight },
        { "NeogitHunkHeader", colors.vscDiffGreenDark, colors.vscSplitLight },
        { "NeogitDiffContext", colors.vscLeftDark, colors.vscPopupFront },
        { "NeogitDiffAdd", colors.vscDiffGreenDark, colors.vscGitAdded },
        { "NeogitDiffDelete", colors.vscDiffRedDark, colors.vscGitDeleted },
        { "NeogitDiffHeaderHighlight", colors.vscBack, colors.vscSplitLight },
        { "NeogitHunkHeaderHighlight", colors.vscDiffGreenDark, colors.vscSplitLight },
        { "NeogitDiffContextHighlight", colors.vscLeftMid, colors.vscPopupFront },
        { "NeogitDiffAddHighlight", colors.vscDiffGreenLight, colors.vscGitAdded },
        { "NeogitDiffDeleteHighlight", colors.vscDiffRedLight, colors.vscGitDeleted },
      }

      for _, def in ipairs(neogit_bg_fg) do
        vim.cmd(string.format("hi def %s guibg=%s guifg=%s", def[1], def[2], def[3]))
      end

      ApplyCommonHighlights()
    end,
  },
}
