return {
  "luckasRanarison/tailwind-tools.nvim",
  build = ":UpdateRemotePlugins",
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "neovim/nvim-lspconfig",
  },
  opts = {
    document_color = { enabled = false },
    conceal = { enabled = false },
    server = { override = true },
  },
}
