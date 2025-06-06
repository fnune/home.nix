local constants = require("constants")

vim.cmd("syntax enable")
vim.cmd("syntax sync minlines=10000")

vim.cmd("filetype plugin indent on")
vim.cmd("set ignorecase smartcase")
vim.opt.autoindent = true
vim.opt.autoread = true
vim.opt.cmdheight = 2
vim.opt.cursorline = true
vim.opt.encoding = "utf-8"
vim.opt.expandtab = true
vim.opt.exrc = true
vim.opt.hidden = true
vim.opt.laststatus = 3
vim.opt.hlsearch = true
vim.opt.incsearch = true
vim.opt.lazyredraw = true
vim.opt.linebreak = true
vim.opt.list = true
vim.opt.listchars = constants.listchars.normal
vim.opt.number = true
vim.opt.redrawtime = 10000
vim.opt.relativenumber = false
vim.opt.scrolloff = 6
vim.opt.secure = true
vim.opt.shiftwidth = 2
vim.opt.shortmess = vim.opt.shortmess + "Ic"
vim.opt.showcmd = true
vim.opt.showmatch = true
vim.opt.showmode = false
vim.opt.signcolumn = "yes"
vim.opt.smartindent = true
vim.opt.smarttab = true
vim.opt.softtabstop = 2
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.tabstop = 2
vim.opt.textwidth = 0
vim.opt.ttimeout = true
vim.opt.ttimeoutlen = 100
vim.opt.timeoutlen = 500
vim.opt.wildmenu = true
vim.opt.winborder = constants.floating_border
vim.opt.wrap = false

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
