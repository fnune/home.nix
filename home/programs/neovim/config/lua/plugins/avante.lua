return {
  "yetone/avante.nvim",
  event = "VeryLazy",
  lazy = false,
  version = "*",
  dependencies = {
    "MunifTanjim/nui.nvim",
    "nvim-lua/plenary.nvim",
    "nvim-telescope/telescope.nvim",
    "nvim-tree/nvim-web-devicons",
    "stevearc/dressing.nvim",
  },
  opts = {
    provider = "claude",
    hints = { enabled = false },
    file_selector = {
      provider = "telescope",
      provider_opts = {
        get_filepaths = function(params)
          local cwd = params.cwd
          local selected_filepaths = params.selected_filepaths

          local cmd = string.format("rg --files --hidden --follow --glob '!.git/' '%s'", vim.fn.fnameescape(cwd))
          local output = vim.fn.system(cmd)

          local filepaths = vim.split(output, "\n", { trimempty = true })
          filepaths = vim.tbl_map(function(path)
            return path:sub(#cwd + 2) -- +2 to account for the trailing slash
          end, filepaths)

          return vim
            .iter(filepaths)
            :filter(function(filepath)
              return not vim.tbl_contains(selected_filepaths, filepath)
            end)
            :totable()
        end,
      },
    },
  },
}
