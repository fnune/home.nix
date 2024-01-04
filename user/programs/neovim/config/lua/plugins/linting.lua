return {
  "mfussenegger/nvim-lint",
  config = function()
    local lint = require("lint")

    lint.linters_by_ft = {
      javascript = {},
      javascriptreact = { "stylelint" },
      typescript = {},
      typescriptreact = { "stylelint" },
      json = { "jsonlint" },
      sh = { "shellcheck" },
      sql = { "sqlfluff" },
      css = { "stylelint" },
      scss = { "stylelint" },
      nix = { "statix" },
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
