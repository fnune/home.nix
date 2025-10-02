return {
  {
    "MeanderingProgrammer/render-markdown.nvim",
    dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" },
    opts = {
      checkbox = { checked = { icon = "" }, unchecked = { icon = "󰄱" } },
      code = { style = "normal", border = "thin", above = "─", below = "─" },
      heading = { enabled = false },
      indent = { enabled = false },
      pipe_table = { style = "normal" },
      sign = { enabled = false },
      file_types = { "markdown", "codecompanion" },
      latex = { enabled = false },
      overrides = {
        buftype = {
          nofile = {
            code = { border = "hide" },
          },
        },
      },
    },
  },
}
