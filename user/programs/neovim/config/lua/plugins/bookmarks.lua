return {
  "MattesGroeger/vim-bookmarks",
  config = function()
    vim.g.bookmark_location_list = 1
    vim.g.bookmark_save_per_working_dir = 1
    vim.g.bookmark_sign = ""
    vim.g.bookmark_no_default_key_mappings = 1

    vim.cmd([[hi! link BookmarkSign @type]])

    local m = require("mapx")

    m.nname("m", "Bookmarks")

    m.nmap("ma", ":BookmarkShowAll<cr>", { silent = true }, "Show all bookmarks")
    m.nmap("mm", ":BookmarkToggle<cr>", { silent = true }, "Toggle bookmark")
    m.nmap("mi", ":BookmarkAnnotate<cr>", { silent = true }, "Annotate bookmark")
    m.nmap("mn", ":BookmarkNext<cr>", { silent = true }, "Next bookmark")
    m.nmap("mp", ":BookmarkPrev<cr>", { silent = true }, "Previous bookmark")
    m.nmap("mc", ":BookmarkClear<cr>", { silent = true }, "Clear bookmark")
    m.nmap("mx", ":BookmarkClearAll<cr>", { silent = true }, "Clear all bookmarks")
    m.nmap("mkk", ":BookmarkMoveUp<cr>", { silent = true }, "Move bookmark up")
    m.nmap("mjj", ":BookmarkMoveDown<cr>", { silent = true }, "Move bookmark down")
    m.nmap("mg", ":BookmarkMoveToLine<cr>", { silent = true }, "Move bookmark to line")
  end,
}
