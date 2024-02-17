return {
  "backdround/improved-search.nvim",
  init = function()
    local s = require("improved-search")
    local m = require("mapx")

    m.noremap("n", s.stable_next, { silent = true })
    m.noremap("N", s.stable_previous, { silent = true })
    m.nnoremap("!", s.current_word, { silent = true })
    m.xnoremap("!", s.in_place, { silent = true })
    m.xnoremap("*", s.forward, { silent = true })
    m.xnoremap("#", s.backward, { silent = true })
    m.nnoremap("|", s.in_place, { silent = true })
  end,
}
