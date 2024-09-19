-- Use oil.nvim and nvim-tree instead
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

if not vim.fn.executable("node") then
  os.execute("volta install node")
end

if not vim.fn.executable("yarn") then
  os.execute("volta install yarn")
end
