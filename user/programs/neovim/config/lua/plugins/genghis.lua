return {
  "chrisgrieser/nvim-genghis",
  dependencies = { "stevearc/dressing.nvim" },
  config = function()
    local genghis = require("genghis")
    genghis.setup()

    -- Emulate vim-eunuch commands that I use most often
    vim.cmd.cabbrev("Delete Genghis trashFile")
    vim.cmd.cabbrev("Rename Genghis renameFile")
  end,
}
