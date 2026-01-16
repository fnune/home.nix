return {
  "stevearc/conform.nvim",
  version = false,
  config = function()
    local conform = require("conform")

    local formatters_by_ft = {
      go = { "goimports", "gofmt" },
      lua = { "stylua" },
      p8lua = { "stylua" },
      nix = { "alejandra" },
      ocaml = { "ocamlformat" },
      python = { "ruff_fix", "ruff_format" },
      rust = { "rustfmt" },
      sh = { "shfmt" },
      sql = { "sqlfluff" },
    }

    local prettier_supported = {
      "css",
      "graphql",
      "html",
      "htmlangular",
      "javascript",
      "javascriptreact",
      "json",
      "markdown",
      "markdown.mdx",
      "scss",
      "typescript",
      "typescriptreact",
      "yaml",
    }

    local prettier = { "prettierd", "prettier", stop_after_first = true }

    for _, vim_ft in ipairs(prettier_supported) do
      formatters_by_ft[vim_ft] = prettier
    end

    conform.setup({
      formatters_by_ft = formatters_by_ft,
      format_on_save = { lsp_format = "fallback" },
      default_format_opts = { lsp_format = "fallback" },
    })
  end,
  keys = {
    {
      "<leader>p",
      function()
        require("conform").format({ async = true })
      end,
      desc = "Format document",
      silent = true,
    },
  },
}
