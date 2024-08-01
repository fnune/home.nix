return {
  "stevearc/conform.nvim",
  config = function()
    local conform = require("conform")

    local formatters_by_ft = {
      lua = { "stylua" },
      nix = { "alejandra" },
      python = { "ruff_fix", "ruff_format" },
      rust = { "rustfmt" },
      sh = { "shfmt" },
      sql = { "sql_formatter" },
    }

    local prettier_supported = {
      "css",
      "graphql",
      "html",
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
    })
  end,
  init = function()
    local m = require("mapx")
    local conform = require("conform")

    m.nmap("<leader>p", function()
      conform.format({ async = true, lsp_fallback = true })
    end, { silent = true }, "Format document")
  end,
}
