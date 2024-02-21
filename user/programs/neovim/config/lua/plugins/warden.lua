local dir = "~/Development/warden.nvim"
return {
  "fnune/warden.nvim",
  dev = true,
  dependencies = { "vim-denops/denops.vim" },
  enabled = function()
    local fs_stat = vim.loop.fs_stat(vim.fn.expand(dir))
    return fs_stat ~= nil
  end,
}
