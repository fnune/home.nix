return {
  "stevearc/oil.nvim",
  opts = {},
  event = "VeryLazy",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  keys = {
    {
      "<leader>o",
      function()
        require("oil").open()
      end,
      desc = "Toggle the directory explorer view",
    },
    {
      "<leader>o",
      function()
        require("oil").close()
      end,
      ft = "oil",
      desc = "Toggle the directory explorer view",
    },
  },
}
