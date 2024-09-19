local dir = "~/Development/eldar.nvim"
return {
  "fnune/eldar.nvim",
  dev = true,
  enabled = function()
    local fs_stat = vim.loop.fs_stat(vim.fn.expand(dir))
    return fs_stat ~= nil
  end,
  dependencies = { "vim-denops/denops.vim" },
  opts = {
    connections = {
      {
        name = "memfault-pg-local",
        type = "postgres",
        host = "localhost",
        port = 5432,
        database = "memfault_db",
        username = "memfault",
        passwordCommand = "echo memfault",
      },
    },
  },
}
