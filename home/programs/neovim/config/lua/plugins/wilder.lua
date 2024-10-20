return {
  "gelguy/wilder.nvim",
  build = ":UpdateRemotePlugins",
  config = function()
    local constants = require("constants")
    local wilder = require("wilder")

    wilder.setup({ modes = { ":" } })
    wilder.set_option(
      "renderer",
      wilder.popupmenu_renderer(wilder.popupmenu_border_theme({
        border = constants.floating_border,
        highlights = { border = "VertSplit" },
      }))
    )
  end,
}
