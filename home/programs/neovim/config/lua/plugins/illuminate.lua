return {
  "RRethy/vim-illuminate",
  config = function()
    local illuminate = require("illuminate")
    illuminate.configure({
      delay = 300,
      filetypes_denylist = {
        "NvimTree",
        "NeogitStatus",
        "NeogitPopup",
        "aerial",
      },
    })
  end,
}
