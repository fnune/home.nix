return {
  "nanozuki/tabby.nvim",
  event = "VimEnter",
  dependencies = "nvim-tree/nvim-web-devicons",
  config = function()
    vim.o.showtabline = 1

    local theme = {
      current_tab = "Normal",
      fill = "StatusLineNC",
      head = "Normal",
      tab = "Normal",
      tail = "Normal",
      win = "Normal",
    }
    local separators = {
      left = "",
      right = "",
    }
    local checkmarks = {
      filled = "",
      empty = "",
    }
    require("tabby").setup({
      line = function(line)
        return {
          line.spacer(),
          line.tabs().foreach(function(tab)
            local hl = tab.is_current() and theme.current_tab or theme.tab
            return {
              line.sep(separators.left, hl, theme.fill),
              tab.is_current() and checkmarks.filled or checkmarks.empty,
              tab.name(),
              tab.number(),
              line.sep(separators.right, hl, theme.fill),
              hl = hl,
              margin = " ",
            }
          end),
          hl = theme.fill,
        }
      end,
    })
  end,
  keys = {
    { "<M-1>", "1gt", desc = "Open tab 1", silent = false },
    { "<M-2>", "2gt", desc = "Open tab 2", silent = false },
    { "<M-3>", "3gt", desc = "Open tab 3", silent = false },
    { "<M-4>", "4gt", desc = "Open tab 4", silent = false },
    { "<M-5>", "5gt", desc = "Open tab 5", silent = false },
    { "<M-6>", "6gt", desc = "Open tab 6", silent = false },
    { "<M-7>", "7gt", desc = "Open tab 7", silent = false },
    { "<M-8>", "8gt", desc = "Open tab 8", silent = false },
    { "<M-9>", "9gt", desc = "Open tab 9", silent = false },
    { "<M-0>", ":tablast<cr>", desc = "Open the last tab", silent = false },
    { "<S-h>", ":tabprevious<cr>", desc = "Previous tab", silent = true },
    { "<S-l>", ":tabnext<cr>", desc = "Next tab", silent = true },
  },
}
