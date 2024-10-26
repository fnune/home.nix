return {
  "fnune/codeactions-on-save.nvim",
  config = function()
    local cos = require("codeactions-on-save")
    cos.register({ "*.py" }, "source.organizeImports")
    cos.register({ "*.ts", "*.tsx" }, "source.organizeImports.biome")
  end,
}
