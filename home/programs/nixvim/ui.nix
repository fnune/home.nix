{
  pkgs-unstable,
  customPlugins,
  floating_border,
  listchars,
  ...
}: {
  extraPlugins = with pkgs-unstable.vimPlugins;
    [
      promise-async
      vim-tmux-navigator
    ]
    ++ [customPlugins.nvim-fundo];

  plugins = {
    which-key = {
      enable = true;
      settings = {
        win = {
          border = floating_border;
          padding = [0 0 0 0];
        };
        icons.mappings = false;
        spec = [
          {
            __unkeyed-1 = "<leader>h";
            group = "Repository history";
          }
          {
            __unkeyed-1 = "<leader>m";
            group = "Global marks";
          }
          {
            __unkeyed-1 = "<leader>s";
            group = "Search";
          }
          {
            __unkeyed-1 = "g";
            group = "Go to";
          }
        ];
      };
    };

    highlight-colors = {
      enable = true;
      settings = {
        render = "virtual";
        virtual_symbol = "";
        enable_tailwind = true;
        exclude_buftypes = ["nofile"];
      };
    };

    visual-whitespace = {
      enable = true;
      settings.list_chars = listchars.visual;
    };

    gx = {
      enable = true;
    };
  };

  extraConfigLua = ''
    require("fundo").install()
    require("fundo").setup({})
  '';

  keymaps = [
    {
      mode = ["n" "x"];
      key = "gx";
      action = ":Browse<CR>";
      options = {
        desc = "Browse";
        silent = true;
      };
    }
  ];
}
