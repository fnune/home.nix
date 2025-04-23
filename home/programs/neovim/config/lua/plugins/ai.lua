return {
  "fnune/magenta.nvim",
  lazy = false,
  branch = "fnune/add-support-snacks",
  build = "npm install --frozen-lockfile",
  opts = {
    picker = "snacks",
    sidebar_position = "right",
  },
}
