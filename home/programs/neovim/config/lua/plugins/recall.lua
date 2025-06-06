return {
  "fnune/recall.nvim",
  opts = {},
  keys = {
    {
      "<leader>mm",
      function()
        require("recall").toggle()
      end,
      desc = "Toggle recall",
    },
    {
      "<leader>mn",
      function()
        require("recall").goto_next()
      end,
      desc = "Go to next recall",
    },
    {
      "<leader>mp",
      function()
        require("recall").goto_prev()
      end,
      desc = "Go to previous recall",
    },
    {
      "<leader>mc",
      function()
        require("recall").clear()
      end,
      desc = "Clear recall",
    },
    {
      "<leader>ml",
      function()
        require("recall.snacks").pick()
      end,
      desc = "Pick recall",
    },
  },
}
