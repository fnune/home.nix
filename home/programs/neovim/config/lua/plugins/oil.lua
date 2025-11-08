return {
  "stevearc/oil.nvim",
  opts = {},
  event = "VeryLazy",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  keys = {
    {
      "<leader>O",
      function()
        require("oil").open()
      end,
      desc = "Toggle the directory explorer view",
    },
    {
      "<leader>O",
      function()
        require("oil").close()
      end,
      ft = "oil",
      desc = "Toggle the directory explorer view",
    },
  },
}
