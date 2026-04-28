local constants = require("constants")

vim.cmd("syntax enable")
vim.cmd("syntax sync minlines=10000") -- fixes broken highlighting in long files
vim.cmd("filetype plugin indent on")

vim.opt.encoding = "utf-8"

-- Indentation
vim.opt.autoindent = true
vim.opt.smartindent = true
vim.opt.smarttab = true
vim.opt.expandtab = true
vim.opt.shiftwidth = 2
vim.opt.softtabstop = 2
vim.opt.tabstop = 2

-- Search
vim.cmd("set ignorecase smartcase")
vim.opt.hlsearch = true
vim.opt.incsearch = true
vim.opt.showmatch = true

-- Wrapping & whitespace display
vim.opt.wrap = false
vim.opt.linebreak = true
vim.opt.breakindent = true -- keep indent on wrapped lines
vim.opt.breakindentopt = "list:-1" -- align list continuations under the text
vim.opt.textwidth = 0 -- no auto line breaks; wrap is visual only
vim.opt.list = true
vim.opt.listchars = constants.listchars.normal

-- UI
vim.opt.number = true
vim.opt.relativenumber = false
vim.opt.cursorline = true
vim.opt.scrolloff = 6
vim.opt.cmdheight = 2
vim.opt.laststatus = 3 -- one global statusline
vim.opt.signcolumn = "yes" -- always on; prevents jitter
vim.opt.showcmd = true
vim.opt.showmode = false -- statusline already shows the mode
vim.opt.wildmenu = true
vim.opt.winborder = constants.floating_border
vim.opt.shortmess = vim.opt.shortmess + "Ic" -- skip intro, silence completion chatter

-- Buffer & editing behavior
vim.opt.autoread = true
vim.opt.hidden = true

-- Splits
vim.opt.splitbelow = true
vim.opt.splitright = true

-- Load project-local .nvimrc/.exrc, but only with `secure` restrictions.
vim.opt.exrc = true
vim.opt.secure = true

-- Performance
vim.opt.lazyredraw = true
vim.opt.redrawtime = 10000 -- ms before giving up on syntax highlighting

-- Timeouts: ttimeout* governs terminal escape sequences, timeoutlen governs mappings.
vim.opt.ttimeout = true
vim.opt.ttimeoutlen = 100
vim.opt.timeoutlen = 500

vim.opt.fillchars:append({
  diff = "╱",
  foldopen = constants.signs.caret_down,
  foldclose = constants.signs.caret_right,
})

-- This is OK if swapfile is false because we won't be writing
-- to the swap file the whole time, ruining the SSD.
vim.opt.updatetime = 100
vim.opt.backup = false
vim.opt.swapfile = false
vim.opt.writebackup = false

-- Usually, deprecated resources are used by plugins and I want
-- to opt out of messages warning me of their impending removal.
vim.deprecate = function() end

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
