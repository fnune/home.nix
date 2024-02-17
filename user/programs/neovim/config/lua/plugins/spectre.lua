return {
  "nvim-pack/nvim-spectre",
  dependencies = { "nvim-lua/plenary.nvim" },
  opts = {
    highlight = {
      ui = "Comment",
      search = "NeogitDiffDelete",
      replace = "NeogitDiffAdd",
    },
  },
  init = function()
    local m = require("mapx")
    local spectre = require("spectre")

    m.nname("<leader>s", "Search")
    m.nmap("<leader>sr", function()
      spectre.toggle()
    end, "Search and replace")

    m.nmap("<leader>sw", function()
      spectre.open_visual({ select_word = true })
    end, "Search and replace current word")

    m.xmap("<leader>sw", function()
      vim.cmd("esc")
      spectre.open_visual()
    end, "Search and replace current word")

    m.nmap("<leader>sp", function()
      spectre.open_file_search({ select_word = true })
    end, "Search and replace on current file")
  end,
}
