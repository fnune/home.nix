return {
  "mfussenegger/nvim-lint",
  config = function()
    local lint = require("lint")

    lint.linters_by_ft = {
      css = { "stylelint" },
      javascript = {},
      javascriptreact = { "stylelint" },
      json = { "jsonlint" },
      lua = { "luacheck" },
      nix = { "statix" },
      scss = { "stylelint" },
      sh = { "shellcheck" },
      typescript = {},
      typescriptreact = { "stylelint" },
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
