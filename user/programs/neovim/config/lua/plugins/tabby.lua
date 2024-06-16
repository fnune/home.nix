return {
  "nanozuki/tabby.nvim",
  event = "VimEnter",
  dependencies = "nvim-tree/nvim-web-devicons",
  config = function()
    local m = require("mapx")
    m.nmap("<M-1>", "1gt", { silent = false }, "Open tab 1")
    m.nmap("<M-2>", "2gt", { silent = false }, "Open tab 2")
    m.nmap("<M-3>", "3gt", { silent = false }, "Open tab 3")
    m.nmap("<M-4>", "4gt", { silent = false }, "Open tab 4")
    m.nmap("<M-5>", "5gt", { silent = false }, "Open tab 5")
    m.nmap("<M-6>", "6gt", { silent = false }, "Open tab 6")
    m.nmap("<M-7>", "7gt", { silent = false }, "Open tab 7")
    m.nmap("<M-8>", "8gt", { silent = false }, "Open tab 8")
    m.nmap("<M-9>", "9gt", { silent = false }, "Open tab 9")
    m.nmap("<M-0>", ":tablast<cr>", { silent = false }, "Open the last tab")

    m.nmap("<S-h>", ":tabprevious<cr>", { silent = true }, "Previous tab")
    m.nmap("<S-l>", ":tabnext<cr>", { silent = true }, "Next tab")

    m.nmap("<leader>H", ":0tabnew<cr>", { silent = true }, "Create a new last tab")
    m.nmap("<leader>L", ":$tabnew<cr>", { silent = true }, "Create a new first tab")
    m.nmap("<leader>O", ":$tabe %<cr>", { silent = true }, "Open this buffer in a new tab")

    vim.o.showtabline = 2

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
    require("tabby.tabline").set(function(line)
      return {
        line
          .wins_in_tab(line.api.get_current_tab(), function(win)
            local buftype = win.buf().type()
            if buftype == "quickfix" or buftype == "nofile" then
              return false
            end
            return true
          end)
          .foreach(function(win)
            return {
              line.sep(separators.left, theme.win, theme.fill),
              win.is_current() and checkmarks.filled or checkmarks.empty,
              win.buf_name(),
              line.sep(separators.right, theme.win, theme.fill),
              hl = theme.win,
              margin = " ",
            }
          end),
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
    end)
  end,
}
