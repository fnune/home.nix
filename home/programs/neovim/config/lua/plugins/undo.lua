return {
  {
    "mbbill/undotree",
    version = false,
    event = "VeryLazy",
    keys = {
      { "<leader>u", vim.cmd.UndotreeToggle, desc = "Toggle the 'undo' tree" },
    },
  },
  {
    "kevinhwang91/nvim-fundo",
    dependencies = { "kevinhwang91/promise-async" },
    config = true,
    build = function()
      require("fundo").install()
    end,
    init = function()
      vim.o.undofile = true
    end,
  },
}
