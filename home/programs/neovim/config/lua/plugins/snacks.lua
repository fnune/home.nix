return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  config = function()
    local snacks = require("snacks")
    snacks.setup({
      bigfile = { enabled = true },
      image = { enabled = true },
      input = { enabled = true },
      notifier = { enabled = true },
      zen = { enabled = true, toggles = { dim = false } },
      quickfile = { enabled = true },
      dim = { enabled = false },
      styles = { zen = { backdrop = { blend = 30 } } },
    })
  end,
  keys = {
    {
      "<leader>z",
      function()
        require("snacks").zen()
      end,
      desc = "Toggle zen mode",
      silent = true,
    },
  },
}
