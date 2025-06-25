return {
  "mfussenegger/nvim-lint",
  version = false,
  config = function()
    local lint = require("lint")

    lint.linters_by_ft = {
      css = {},
      json = { "jsonlint" },
      lua = { "luacheck" },
      nix = { "statix" },
      scss = {},
      sh = { "shellcheck" },
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
