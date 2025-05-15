return {
  { "jxnblk/vim-mdx-js" },
  {
    "MeanderingProgrammer/render-markdown.nvim",
    dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" },
    opts = {
      checkbox = { checked = { icon = "" }, unchecked = { icon = "󰄱" } },
      code = { style = "normal", border = "thin", above = "─", below = "─" },
      heading = { position = "inline" },
      indent = { enabled = false },
      pipe_table = { style = "normal" },
      sign = { enabled = false },
      file_types = { "markdown", "Avante" },
      overrides = {
        buftype = {
          nofile = {
            code = { border = "hide" },
          },
        },
      },
    },
  },
  {
    "mzlogin/vim-markdown-toc",
    init = function()
      vim.g.vmt_auto_update_on_save = true
      vim.g.vmt_list_item_char = "-"
    end,
  },
}
