return {
  "mcauley-penney/visual-whitespace.nvim",
  config = function()
    vim.api.nvim_set_hl(0, "VisualWhitespace", { link = "Visual", default = true })
    require("visual-whitespace").setup({
      highlight = { link = "VisualWhitespace" },
    })
  end,
}
