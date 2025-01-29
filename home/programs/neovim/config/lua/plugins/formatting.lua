return {
  "stevearc/conform.nvim",
  version = false,
  config = function()
    local conform = require("conform")

    local formatters_by_ft = {
      lua = { "stylua" },
      nix = { "alejandra" },
      ocaml = { "ocamlformat" },
      python = { "ruff_fix", "ruff_format" },
      rust = { "rustfmt" },
      sh = { "shfmt" },
      sql = { "sql_formatter" },
    }

    local biome_supported = {
      "javascript",
      "javascriptreact",
      "json",
      "typescript",
      "typescriptreact",
    }

    local prettier_supported = {
      "css",
      "graphql",
      "html",
      "markdown",
      "markdown.mdx",
      "scss",
      "yaml",
    }

    local prettier = { "prettierd", "prettier", stop_after_first = true }

    for _, vim_ft in ipairs(prettier_supported) do
      formatters_by_ft[vim_ft] = prettier
    end

    for _, vim_ft in ipairs(biome_supported) do
      formatters_by_ft[vim_ft] = { "biome" }
    end

    conform.setup({
      formatters_by_ft = formatters_by_ft,
      format_on_save = { lsp_format = "fallback" },
    })
  end,
  keys = {
    {
      "<leader>p",
      function()
        require("conform").format({ async = true, lsp_fallback = true })
      end,
      desc = "Format document",
      silent = true,
    },
  },
}
