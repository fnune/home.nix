return {
  "chentoast/marks.nvim",
  config = function()
    vim.cmd([[hi! link MarkSignHL @type]])

    local group = 0
    local marks = require("marks")
    marks.setup({
      default_mappings = false,
      ["bookmark_" .. group] = { sign = "" },
    })

    local m = require("mapx")
    m.nname("m", "Bookmarks")
    m.nmap("ma", ":BookmarksList " .. group .. "<cr>", { silent = true }, "Show all bookmarks")

    m.nmap("mm", function()
      marks.bookmark_state:toggle_mark(group)
    end, "Toggle bookmark")

    m.nmap("mn", function()
      marks.bookmark_state:next(group)
    end, "Next bookmark")
    m.nmap("mp", function()
      marks.bookmark_state:prev(group)
    end, "Previous bookmark")

    m.nmap("mx", function()
      if vim.fn.confirm("Clear all bookmarks?", "&Yes\n&No", 2) == 1 then
        marks.bookmark_state:delete_all(group)
      end
    end, "Clear all bookmarks")
  end,
}
