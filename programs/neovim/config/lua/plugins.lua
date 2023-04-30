local Plug = vim.fn['plug#']

vim.call('plug#begin')

Plug('AndrewRadev/tagalong.vim')
Plug('Mofiqul/vscode.nvim')
Plug('TimUntersberger/neogit')
Plug('antoinemadec/FixCursorHold.nvim')
Plug('christoomey/vim-tmux-navigator')
Plug('farmergreg/vim-lastplace')
Plug('fgheng/winbar.nvim')
Plug('folke/which-key.nvim')
Plug('jxnblk/vim-mdx-js')
Plug('kristijanhusak/vim-dadbod-ui')
Plug('lewis6991/gitsigns.nvim')
Plug('machakann/vim-swap')
Plug('markonm/traces.vim')
Plug('matze/vim-move')
Plug('mbbill/undotree')
Plug('mfussenegger/nvim-dap')
Plug('mfussenegger/nvim-dap-python')
Plug('neoclide/coc.nvim', { branch = 'release' })
Plug('nvim-lua/plenary.nvim')
Plug('nvim-lualine/lualine.nvim')
Plug('nvim-neotest/neotest')
Plug('nvim-neotest/neotest-jest')
Plug('nvim-neotest/neotest-python')
Plug('nvim-telescope/telescope-fzf-native.nvim', { ['do'] = 'make' })
Plug('nvim-telescope/telescope.nvim', { branch = '0.1.x' })
Plug('nvim-tree/nvim-tree.lua')
Plug('nvim-tree/nvim-web-devicons')
Plug('nvim-treesitter/completion-treesitter')
Plug('nvim-treesitter/nvim-treesitter', { ['do'] = ':TSUpdate' })
Plug('pwntester/octo.nvim')
Plug('rcarriga/nvim-dap-ui')
Plug('rmagatti/auto-session')
Plug('romgrk/barbar.nvim')
Plug('rose-pine/neovim')
Plug('rouge8/neotest-rust')
Plug('sindrets/diffview.nvim')
Plug('theHamsta/nvim-dap-virtual-text')
Plug('tpope/vim-abolish')
Plug('tpope/vim-commentary')
Plug('tpope/vim-dadbod')
Plug('tpope/vim-eunuch')
Plug('tpope/vim-fugitive')
Plug('tpope/vim-repeat')
Plug('tpope/vim-rhubarb')
Plug('tpope/vim-surround')
Plug('tversteeg/registers.nvim')
Plug('tyru/open-browser-github.vim')
Plug('tyru/open-browser.vim')
Plug('vimwiki/vimwiki')

vim.call('plug#end')

require("plugins.auto-session")
require("plugins.barbar")
require("plugins.coc")
require("plugins.dap")
require("plugins.diffview")
require("plugins.fugitive")
require("plugins.gitsigns")
require("plugins.lualine")
require("plugins.neogit")
require("plugins.neotest")
require("plugins.octo")
require("plugins.telescope")
require("plugins.traces")
require("plugins.tree")
require("plugins.treesitter")
require("plugins.which-key")
require("plugins.winbar")
