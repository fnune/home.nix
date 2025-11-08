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
      picker = { enabled = true, layout = { preset = "ivy" } },
      quickfile = { enabled = true },
      styles = { zen = { backdrop = { blend = 30 } } },
      zen = { enabled = true, toggles = { dim = false } },
      -- Disabled:
      dashboard = { enabled = false },
      dim = { enabled = false },
      explorer = { enabled = false },
      lazygit = { enabled = false },
      scope = { enabled = false },
      scroll = { enabled = false },
      statuscolumn = { enabled = false },
      words = { enabled = false },
    })
  end,
  keys = {
    {
      "<leader>f",
      function()
        require("snacks").picker.smart()
      end,
      desc = "Find files",
      silent = true,
    },
    {
      "<leader>F",
      function()
        require("snacks").picker.grep()
      end,
      desc = "Find text in files",
      silent = true,
    },
    {
      "<leader>b",
      function()
        require("snacks").picker.buffers()
      end,
      desc = "Find buffers",
      silent = true,
    },
    {
      "<leader>sS",
      function()
        require("snacks").picker.lsp_symbols()
      end,
      desc = "Find symbols in the document",
      silent = true,
    },
    {
      "<leader>sW",
      function()
        require("snacks").picker.lsp_workspace_symbols()
      end,
      desc = "Find symbols across the workspace",
      silent = true,
    },
    {
      "<leader>sR",
      function()
        require("snacks").picker.resume()
      end,
      desc = "Resume the most recent search",
      silent = true,
    },
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
