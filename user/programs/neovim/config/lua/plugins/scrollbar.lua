return {
  "dstein64/nvim-scrollview",
  config = function()
    local scrollbar = require("scrollview")
    scrollbar.setup({
      signs_on_startup = { "search" },
      signs_overflow = "right",
      search_symbol = { "○" },
    })
  end,
}
