return {
  "nvim-lualine/lualine.nvim",
  dependencies = { "linrongbin16/lsp-progress.nvim" },
  config = function()
    local lualine = require("lualine")
    local lsp_progress = require("lsp-progress")
    lsp_progress.setup({})

    lualine.setup({
      options = {
        component_separators = { "│", "│" },
        globalstatus = true,
        section_separators = { "", "" },
        theme = vim.g.colorscheme,
      },
      -- See defaults: https://github.com/nvim-lualine/lualine.nvim#default-configuration
      sections = {
        lualine_a = { "mode" },
        lualine_b = { "branch", "diff", "diagnostics" },
        lualine_c = {
          { "filename", path = 1 },
          function()
            return require("lsp-progress").progress()
          end,
        },
        lualine_x = { "filetype" },
        lualine_y = { "progress" },
        lualine_z = { "location" },
      },
    })
  end,
}
