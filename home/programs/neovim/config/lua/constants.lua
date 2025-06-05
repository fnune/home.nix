local constants = {
  file_explorer_width_chars = 40,
  floating_border = "rounded",
  signs = {
    caret_down = "",
    caret_right = "",
    error = " ",
    warn = " ",
    hint = "󰋗 ",
    info = " ",
    error_single = "",
    warn_single = "",
    hint_single = "",
    info_single = "",
  },
  listchars = {
    normal = {
      space = " ",
      tab = "  ",
      nbsp = "␣",
      eol = " ",
    },
    visual = {
      space = "·",
      tab = "↦ ",
      nbsp = "␣",
      eol = "↲",
    },
  },
}

return constants
