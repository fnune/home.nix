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

function LinkNeotestHighlights()
  vim.cmd([[
    hi! link NeotestAdapterName Macro
    hi! link NeotestDir Normal
    hi! link NeotestExpandMarker StatusLine
    hi! link NeotestFailed DiagnosticError
    hi! link NeotestFile Normal
    hi! link NeotestFocused Underlined
    hi! link NeotestIndent StatusLine
    hi! link NeotestMarked DiagnosticHint
    hi! link NeotestNamespace Macro
    hi! link NeotestPassed DiagnosticOk
    hi! link NeotestRunning DiagnosticWarn
    hi! link NeotestSkipped StatusLine
    hi! link NeotestTarget Macro
    hi! link NeotestTest Boolean
    hi! link NeotestWinSelect Macro
    hi! link NeotestUnknown StatusLine
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
  LinkNeotestHighlights()
  HighlightItalics()
  HideEndOfBufferCharacters()
end

return {
  { "nvim-treesitter/playground" },
  {
    "Mofiqul/vscode.nvim",
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
          ["BufferTabpageFill"] = { bg = colors.vscTabOther },
          ["Comment"] = { fg = colors.vscGray },
          ["NeogitDiffAdd"] = { fg = colors.vscGitAdded, bg = colors.vscDiffGreenDark },
          ["NeogitDiffAddHighlight"] = { fg = colors.vscGitAdded, bg = colors.vscDiffGreenLight },
          ["NeogitDiffContext"] = { fg = colors.vscPopupFront, bg = colors.vscLeftDark },
          ["NeogitDiffContextHighlight"] = { fg = colors.vscPopupFront, bg = colors.vscLeftMid },
          ["NeogitDiffDelete"] = { fg = colors.vscGitDeleted, bg = colors.vscDiffRedDark },
          ["NeogitDiffDeleteHighlight"] = { fg = colors.vscGitDeleted, bg = colors.vscDiffRedLight },
          ["NeogitDiffHeader"] = { fg = colors.vscSplitLight, bg = colors.vscBack },
          ["NeogitDiffHeaderHighlight"] = { fg = colors.vscSplitLight, bg = colors.vscBack },
          ["NeogitHunkHeader"] = { fg = colors.vscSplitLight, bg = colors.vscDiffGreenDark },
          ["NeogitHunkHeaderHighlight"] = { fg = colors.vscSplitLight, bg = colors.vscDiffGreenDark },
          ["Pmenu"] = { fg = colors.vscPopupFront, bg = "NONE" },
          ["PmenuSel"] = { fg = "NONE", bg = colors.vscPopupHighlightBlue },
          ["SpecialComment"] = { fg = colors.vscGray },
        },
      })

      vscode.load()

      ApplyCommonHighlights()
    end,
  },
}
