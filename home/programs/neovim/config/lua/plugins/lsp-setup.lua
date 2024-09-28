return {
  { "saecki/live-rename.nvim", config = true },
  {
    "folke/trouble.nvim",
    opts = {},
    cmd = "Trouble",
    keys = {
      { "<leader>x", ":Trouble diagnostics<cr>", desc = "List diagnostics", silent = true },
    },
  },
  {
    "neovim/nvim-lspconfig",
    init = function()
      local constants = require("constants")

      vim.diagnostic.config({
        float = { border = constants.floating_border },
        severity_sort = true,
        signs = false,
      })

      vim.lsp.handlers["textDocument/hover"] =
        vim.lsp.with(vim.lsp.handlers.hover, { border = constants.floating_border })
      vim.lsp.handlers["textDocument/signatureHelp"] =
        vim.lsp.with(vim.lsp.handlers.signature_help, { border = constants.floating_border })

      local signs = {
        Error = constants.signs.error,
        Warn = constants.signs.warn,
        Hint = constants.signs.hint,
        Info = constants.signs.info,
      }
      for type, icon in pairs(signs) do
        local hl = "DiagnosticSign" .. type
        vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
      end

      -- https://github.com/neovim/nvim-lspconfig/issues/1931
      local notify = vim.notify
      vim.notify = function(msg, ...)
        if msg ~= "No information available" then
          return notify(msg, ...)
        end
      end
    end,
    keys = {
      {
        "K",
        function()
          vim.lsp.buf.hover()
        end,
        desc = "Show documentation",
        silent = true,
      },
      {
        "<leader>k",
        function()
          vim.diagnostic.goto_prev()
        end,
        desc = "Previous diagnostic",
        silent = true,
      },
      {
        "<leader>j",
        function()
          vim.diagnostic.goto_next()
        end,
        desc = "Next diagnostic",
        silent = true,
      },
      {
        "<leader>r",
        function()
          require("live-rename").rename()
        end,
        desc = "Rename symbol",
        silent = true,
      },
      {
        "gd",
        function()
          vim.lsp.buf.definition()
        end,
        desc = "Go to definition",
        silent = true,
      },
      {
        "gD",
        function()
          vim.lsp.buf.declaration()
        end,
        desc = "Go to declaration",
        silent = true,
      },
      {
        "gi",
        function()
          vim.lsp.buf.implementation()
        end,
        desc = "Go to implementation",
        silent = true,
      },
      {
        "gT",
        function()
          vim.lsp.buf.type_definition()
        end,
        desc = "Go to type definition",
        silent = true,
      },
      {
        "gr",
        function()
          vim.lsp.buf.references()
        end,
        desc = "Show references",
        silent = true,
      },
      {
        "<leader>ac",
        function()
          vim.lsp.buf.code_action()
        end,
        mode = { "n", "x" },
        desc = "Apply code action (normal)",
        silent = true,
      },
    },
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
    end,
    keys = {
      {
        "<C-s>",
        function()
          require("lsp_signature").toggle_float_win()
        end,
        mode = "i",
        desc = "Toggle LSP function signature help in insert mode",
        silent = true,
      },
      {
        "<C-s>",
        function()
          require("lsp_signature").toggle_float_win()
        end,
        desc = "Toggle LSP function signature help in normal mode",
        silent = true,
      },
    },
  },
}
