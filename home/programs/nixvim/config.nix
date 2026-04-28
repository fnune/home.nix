{
  pkgs,
  pkgs-unstable,
  lib,
  ...
}: let
  customPlugins = import ./pkgs {pkgs = pkgs-unstable;};

  floating_border = "rounded";
  signs = {
    caret_down = "";
    caret_right = "";
    error = " ";
    warn = " ";
    hint = "󰋗 ";
    info = " ";
    error_single = "";
    warn_single = "";
    hint_single = "";
    info_single = "";
  };
  listchars = {
    normal = {
      space = " ";
      tab = "  ";
      nbsp = "␣";
      eol = " ";
    };
    visual = {
      space = "·";
      tab = "↦ ";
      nbsp = "␣";
      eol = "↲";
    };
  };
  file_explorer_width_chars = 40;

  raw = lua: {__raw = lua;};
in {
  imports = [
    ./completion.nix
    ./editing.nix
    ./files.nix
    ./git.nix
    ./lsp.nix
    ./markdown.nix
    ./snacks.nix
    ./theme.nix
    ./treesitter.nix
    ./ui.nix
  ];

  _module.args = {inherit customPlugins floating_border signs listchars file_explorer_width_chars raw;};

  package = pkgs-unstable.neovim-unwrapped;

  withNodeJs = true;
  withPython3 = true;
  withRuby = true;

  extraLuaPackages = ps: [ps.magick];

  globals = {
    mapleader = " ";
    maplocalleader = "g";
    loaded_netrw = 1;
    loaded_netrwPlugin = 1;
    netrw_nogx = 1;
    traces_abolish_integration = 1;
  };

  opts = {
    encoding = "utf-8";

    autoindent = true;
    smartindent = true;
    smarttab = true;
    expandtab = true;
    shiftwidth = 2;
    softtabstop = 2;
    tabstop = 2;

    ignorecase = true;
    smartcase = true;
    hlsearch = true;
    incsearch = true;
    showmatch = true;

    wrap = false;
    linebreak = true;
    breakindent = true;
    breakindentopt = "list:-1";
    textwidth = 0;
    list = true;
    listchars = listchars.normal;

    number = true;
    relativenumber = false;
    cursorline = true;
    scrolloff = 6;
    cmdheight = 2;
    laststatus = 3;
    signcolumn = "yes";
    showcmd = true;
    showmode = false;
    wildmenu = true;
    winborder = floating_border;
    shortmess = "filnxtToOFIc";

    autoread = true;
    hidden = true;

    splitbelow = true;
    splitright = true;

    exrc = true;
    secure = true;

    lazyredraw = true;
    redrawtime = 10000;

    ttimeout = true;
    ttimeoutlen = 100;
    timeoutlen = 500;

    updatetime = 100;
    backup = false;
    swapfile = false;
    writebackup = false;

    termguicolors = true;
    undofile = true;
  };

  extraConfigLuaPre = ''
    vim.cmd("syntax enable")
    vim.cmd("syntax sync minlines=10000")
    vim.cmd("filetype plugin indent on")

    vim.opt.fillchars:append({
      diff = "╱",
      foldopen = "${signs.caret_down}",
      foldclose = "${signs.caret_right}",
    })

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
  '';

  extraConfigLua = ''
    -- https://github.com/neovim/nvim-lspconfig/issues/1931
    local notify = vim.notify
    vim.notify = function(msg, ...)
      if msg ~= "No information available" then
        return notify(msg, ...)
      end
    end
  '';

  keymaps = [
    {
      mode = "n";
      key = "0";
      action = "^";
      options = {
        noremap = true;
        desc = "Move to the first non-whitespace character";
      };
    }
    {
      mode = "n";
      key = "<C-d>";
      action = "<C-d>zz";
      options = {
        noremap = true;
        desc = "Scroll down and center the buffer";
      };
    }
    {
      mode = "n";
      key = "<C-u>";
      action = "<C-u>zz";
      options = {
        noremap = true;
        desc = "Scroll up and center the buffer";
      };
    }
    {
      mode = "n";
      key = "<leader>l";
      action = "<cmd>nohlsearch<cr><cmd>echo ''<cr>";
      options.desc = "Clear search and message";
    }
    {
      mode = "n";
      key = "<leader>q";
      action = ":quit<cr>";
      options = {
        desc = "Quit";
        silent = true;
      };
    }
    {
      mode = "n";
      key = "Q";
      action = "<nop>";
      options = {
        noremap = true;
        desc = "Disabled";
      };
    }
    {
      mode = "n";
      key = "j";
      action = "gj";
      options = {
        noremap = true;
        desc = "Move to next display line";
      };
    }
    {
      mode = "n";
      key = "k";
      action = "gk";
      options = {
        noremap = true;
        desc = "Previous display line";
      };
    }
    {
      mode = "t";
      key = "<C-t><esc>";
      action = "<C-\\><C-n>";
      options.desc = "Exit insert mode in the terminal";
    }
  ];

  diagnostic.settings = {
    float.border = floating_border;
    severity_sort = true;
    signs = false;
    virtual_text.prefix = signs.error_single;
  };
}
