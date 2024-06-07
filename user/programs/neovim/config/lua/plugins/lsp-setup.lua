return {
  { "rmagatti/goto-preview" },
  {
    "folke/trouble.nvim",
    opts = {},
    cmd = "Trouble",
    init = function()
      local m = require("mapx")
      m.nmap("<leader>x", ":Trouble diagnostics<cr>", { silent = true }, "List diagnostics")
    end,
  },
  {
    "neovim/nvim-lspconfig",
    init = function()
      local constants = require("constants")
      local goto_preview = require("goto-preview")

      goto_preview.setup({ border = constants.floating_border })

      vim.diagnostic.config({
        virtual_text = { severity = vim.diagnostic.severity.ERROR, source = "if_many", spacing = 1 },
        underline = true,
        severity_sort = true,
        signs = { severity = vim.diagnostic.severity.ERROR },
        float = { border = constants.floating_border },
      })

      vim.lsp.handlers["textDocument/hover"] =
        vim.lsp.with(vim.lsp.handlers.hover, { border = constants.floating_border })
      vim.lsp.handlers["textDocument/signatureHelp"] =
        vim.lsp.with(vim.lsp.handlers.signature_help, { border = constants.floating_border })

      local signs = { Error = " ", Warn = " ", Hint = "󰌵 ", Info = "󰋼 " }
      for type, icon in pairs(signs) do
        local hl = "DiagnosticSign" .. type
        vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
      end

      local m = require("mapx")
      local bufopts = { noremap = true, silent = true }

      m.nmap("K", function()
        vim.lsp.buf.hover()
      end, bufopts, "Show documentation")

      m.nmap("<leader>k", function()
        vim.diagnostic.goto_prev()
      end, "Previous diagnostic")
      m.nmap("<leader>j", function()
        vim.diagnostic.goto_next()
      end, "Next diagnostic")

      m.nmap("<leader>r", function()
        vim.lsp.buf.rename()
      end, bufopts, "Rename symbol")

      m.nname("g", "Go to")
      m.nname("gp", "Go to preview")

      -- Go to definition
      m.nmap("gd", function()
        vim.lsp.buf.definition()
      end, bufopts, "Go to definition")
      m.nmap("gpd", function()
        goto_preview.goto_preview_definition()
      end, "Go to definition preview")

      -- Go to declaration
      m.nmap("gD", function()
        vim.lsp.buf.declaration()
      end, bufopts, "Go to declaration")
      m.nmap("gpD", function()
        goto_preview.goto_preview_declaration()
      end, "Go to declaration preview")

      -- Go to implementation
      m.nmap("gi", function()
        vim.lsp.buf.implementation()
      end, bufopts, "Go to implementation")
      m.nmap("gpi", function()
        goto_preview.goto_preview_implementation()
      end, "Go to implementation preview")

      -- Go to type definition
      m.nmap("gT", function()
        vim.lsp.buf.type_definition()
      end, bufopts, "Go to type definition")
      m.nmap("gpt", function()
        goto_preview.goto_preview_type_definition()
      end, "Go to type definition preview")

      -- Go to references
      m.nmap("gr", function()
        vim.lsp.buf.references()
      end, bufopts, "Show references")
      m.nmap("gpr", function()
        goto_preview.goto_preview_references()
      end, "Go to references preview")

      -- Close all preview windows
      m.nmap("gP", function()
        goto_preview.close_all_win()
      end, "Close all preview windows")

      m.nname("<leader>a", "Code actions")
      m.nmap("<leader>ac", function()
        vim.lsp.buf.code_action()
      end, "Apply code action (normal)")
      m.xmap("<leader>ac", function()
        vim.lsp.buf.code_action()
      end, "Apply code action (visual)")
    end,
  },
  {
    "ray-x/lsp_signature.nvim",
    config = function()
      local constants = require("constants")
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
        signature.toggle_float_win()
      end, "Toggle LSP function signature help in insert mode")

      m.nnoremap(toggle_key, function()
        signature.toggle_float_win()
      end, "Toggle LSP function signature help in normal mode")
    end,
  },
}
