local constants = require("constants")
return {
  "saghen/blink.cmp",
  lazy = false,
  dependencies = "rafamadriz/friendly-snippets",
  version = "v0.*",
  opts = {
    keymap = { accept = { "<Tab>", "<cr>" } },
    highlight = { use_nvim_cmp_as_default = true },
    nerd_font_variant = "normal",
    trigger = { signature_help = { enabled = true } },
    windows = {
      autocomplete = {
        border = constants.floating_border,
        winhighlight = "CursorLine:PmenuSel",
        draw = "reversed",
      },
      documentation = {
        border = constants.floating_border,
        auto_show = true,
      },
      signature_help = {
        border = constants.floating_border,
      },
    },
  },
}
