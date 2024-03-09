return {
  { "jxnblk/vim-mdx-js" },
  {
    "mzlogin/vim-markdown-toc",
    init = function()
      vim.g.vmt_auto_update_on_save = true
      vim.g.vmt_list_item_char = "-"
    end,
  },
}
