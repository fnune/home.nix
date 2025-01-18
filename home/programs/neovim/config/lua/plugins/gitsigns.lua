return {
  "lewis6991/gitsigns.nvim",
  config = true,
  keys = {
    {
      "<leader>J",
      function()
        require("gitsigns").nav_hunk("next")
      end,
      desc = "Navigate to the next hunk",
    },
    {
      "<leader>K",
      function()
        require("gitsigns").nav_hunk("prev")
      end,
      desc = "Navigate to the previous hunk",
    },
  },
}
