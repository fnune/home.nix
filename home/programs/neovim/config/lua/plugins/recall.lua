return {
  "fnune/recall.nvim",
  dev = true,
  config = function()
    local recall = require("recall")
    recall.setup({})
  end,
  keys = {
    {
      "<leader>mm",
      function()
        require("recall").toggle()
      end,
      desc = "Toggle a global mark",
      silent = true,
    },
    {
      "<leader>mn",
      function()
        require("recall").goto_next()
      end,
      desc = "Go to the next global mark",
      silent = true,
    },
    {
      "<leader>mp",
      function()
        require("recall").goto_prev()
      end,
      desc = "Go to the previous global mark",
      silent = true,
    },
    {
      "<leader>mc",
      function()
        require("recall").clear()
      end,
      desc = "Clear all global marks",
      silent = true,
    },
    { "<leader>ml", ":Telescope recall theme=ivy<CR>", desc = "Find global marks", silent = true },
  },
}
