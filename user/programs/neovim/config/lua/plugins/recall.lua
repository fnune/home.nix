return {
  "fnune/recall.nvim",
  dev = true,
  config = function()
    local m = require("mapx")
    local recall = require("recall")

    recall.setup({})

    m.nname("<leader>m", "Global marks")
    m.nmap("<leader>mm", recall.toggle, "Toggle a global mark")
    m.nmap("<leader>mn", recall.goto_next, "Go to the next global mark")
    m.nmap("<leader>mp", recall.goto_prev, "Go to the previous global mark")
    m.nmap("<leader>mc", recall.clear, "Clear all global marks")
  end,
}
