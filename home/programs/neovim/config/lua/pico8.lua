local function in_pico8_project(path)
  local dir = vim.fn.fnamemodify(path, ":h")
  while dir ~= "/" do
    if #vim.fn.glob(dir .. "/*.p8", false, true) > 0 then
      return true
    end
    dir = vim.fn.fnamemodify(dir, ":h")
  end
  return false
end

vim.filetype.add({
  extension = {
    p8 = "p8",
    lua = function(path)
      if in_pico8_project(path) then
        return "p8lua"
      end
      return "lua"
    end,
  },
})

vim.treesitter.language.register("lua", "p8lua")
