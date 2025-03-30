return {
  "josephburgess/nvumi",
  dependencies = { "folke/snacks.nvim" },
  opts = {
    virtual_text = "inline",
    prefix = " 󰪚 ",
    date_format = "iso",
    keys = {
      run = "<CR>",
      reset = "R",
      yank = "<leader>y",
      yank_all = "<leader>Y",
    },
  },
  keys = {
    { "<leader>c", ":Nvumi<cr>", desc = "Toggle the natural language calculator scratchpad", silent = true },
  },
}
