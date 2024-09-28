return {
  "nvim-pack/nvim-spectre",
  dependencies = { "nvim-lua/plenary.nvim" },
  config = function()
    local spectre = require("spectre")

    spectre.setup({
      highlight = {
        ui = "Comment",
        search = "NeogitDiffDelete",
        replace = "NeogitDiffAdd",
      },
      mapping = {
        ["send_to_qf"] = {
          map = "<M-q>", -- Change the keybinding only
          cmd = "<cmd>lua require('spectre.actions').send_to_qf()<CR>",
          desc = "send all items to quickfix",
        },
      },
      default = {
        find = { options = {} }, -- Disable ignore-case default
      },
    })
  end,
  keys = {
    {
      "<leader>sr",
      function()
        require("spectre").toggle()
      end,
      desc = "Search and replace",
    },
    {
      "<leader>sw",
      function()
        require("spectre").open_visual({ select_word = true })
      end,
      mode = { "n", "x" },
      desc = "Search and replace current word",
    },
    {
      "<leader>sp",
      function()
        require("spectre").open_file_search({ select_word = true })
      end,
      desc = "Search and replace on current file",
    },
  },
}
