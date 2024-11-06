return {
  "mfussenegger/nvim-lint",
  config = function()
    local lint = require("lint")

    lint.linters_by_ft = {
      css = {},
      javascript = { "eslint_d" },
      javascriptreact = { "eslint_d" },
      json = { "jsonlint" },
      lua = { "luacheck" },
      nix = { "statix" },
      scss = {},
      sh = { "shellcheck" },
      typescript = { "eslint_d" },
      typescriptreact = { "eslint_d" },
    }
  end,

  init = function()
    local lint = require("lint")
    vim.api.nvim_create_autocmd({ "BufWritePost", "BufReadPost" }, {
      callback = function()
        lint.try_lint()
      end,
    })
  end,
}
