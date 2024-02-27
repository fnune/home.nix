return {
  {
    "utilyre/barbecue.nvim",
    name = "barbecue",
    version = "*",
    dependencies = {
      "SmiteshP/nvim-navic",
      "nvim-tree/nvim-web-devicons",
    },
    config = function()
      local barbecue = require("barbecue")
      barbecue.setup({
        exclude_filetypes = { "gitcommit", "NeogitStatus", "NeogitCommitMessage" },
        show_modified = true,
      })

      vim.api.nvim_create_autocmd({
        "BufModifiedSet",
        "BufWinEnter",
        "CursorHold",
        "InsertLeave",
        "WinResized",
      }, {
        group = vim.api.nvim_create_augroup("barbecue.updater", {}),
        callback = function()
          require("barbecue.ui").update()
        end,
      })
    end,
  },
}
