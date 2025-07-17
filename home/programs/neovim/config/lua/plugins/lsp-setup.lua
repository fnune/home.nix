return {
  { "saecki/live-rename.nvim", config = true },
  { "j-hui/fidget.nvim", config = true },
  {
    "folke/trouble.nvim",
    opts = {},
    cmd = "Trouble",
    keys = {
      { "<leader>x", ":Trouble diagnostics<cr>", desc = "List diagnostics", silent = true },
    },
  },
  {
    "Wansmer/symbol-usage.nvim",
    event = "LspAttach",
    config = function()
      require("symbol-usage").setup({ vt_position = "end_of_line", request_pending_text = false })
    end,
  },
  {
    "neovim/nvim-lspconfig",
    init = function()
      local constants = require("constants")

      vim.diagnostic.config({
        float = { border = constants.floating_border },
        severity_sort = true,
        signs = false,
        virtual_text = { prefix = constants.signs.error_single },
      })

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
          vim.lsp.buf.hover({ max_width = 80 })
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
        ":Telescope lsp_definitions<CR>",
        desc = "Go to definition",
        silent = true,
      },
      {
        "gD",
        ":Telescope lsp_declarations<CR>",
        desc = "Go to declaration",
        silent = true,
      },
      {
        "gi",
        ":Telescope lsp_implementations<CR>",
        desc = "Go to implementation",
        silent = true,
      },
      {
        "gT",
        ":Telescope lsp_type_definitions<CR>",
        desc = "Go to type definition",
        silent = true,
      },
      {
        "gr",
        ":Telescope lsp_references<CR>",
        desc = "Show references",
        silent = true,
      },
      {
        "<c-space>",
        function()
          vim.lsp.buf.code_action()
        end,
        mode = { "n", "x" },
        desc = "Apply code action (normal)",
        silent = true,
      },
    },
  },
}
