local constants = require("constants")
return {
  "ray-x/lsp_signature.nvim",
  config = function()
    local toggle_key = "<C-s>"

    local signature = require("lsp_signature")
    signature.setup({
      bind = true,
      floating_window = true,
      handler_opts = { border = constants.floating_border },
      hint_enable = false,
      toggle_key = toggle_key,
    })

    local m = require("mapx")

    m.inoremap(toggle_key, function()
      vim.lsp.buf.signature_help()
    end, "Toggle LSP function signature help in insert mode")

    m.nnoremap(toggle_key, function()
      vim.lsp.buf.signature_help()
    end, "Toggle LSP function signature help in normal mode")
  end,
}
