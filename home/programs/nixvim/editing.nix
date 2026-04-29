{
  pkgs-unstable,
  customPlugins,
  lib,
  ...
}: {
  extraPackages = with pkgs-unstable; [
    prettierd
    python3Packages.black
    delve
    python3Packages.debugpy
  ];

  extraPlugins = with pkgs-unstable.vimPlugins;
    [
      vim-abolish
      vim-eunuch
      vim-just
      vim-move
      vim-repeat
      traces-vim
    ]
    ++ [customPlugins.improved-ft-nvim];

  plugins = {
    nvim-autopairs = {
      enable = true;
      settings.disable_filetype = ["gitcommit" "markdown"];
    };

    comment = {
      enable = true;
      settings.pre_hook = lib.nixvim.mkRaw "require('ts_context_commentstring.integrations.comment_nvim').create_pre_hook()";
    };

    ts-context-commentstring = {
      enable = true;
      settings.enable_autocmd = false;
    };

    ts-autotag = {
      enable = true;
    };

    vim-surround = {
      enable = true;
    };

    conform-nvim = {
      enable = true;
      settings = let
        prettier = {
          __unkeyed-1 = "prettierd";
          __unkeyed-2 = "prettier";
          stop_after_first = true;
        };
      in {
        format_on_save.lsp_format = "fallback";
        default_format_opts.lsp_format = "fallback";
        formatters_by_ft = {
          go = ["goimports" "gofmt"];
          lua = ["stylua"];
          p8lua = ["stylua"];
          nix = ["alejandra"];
          ocaml = ["ocamlformat"];
          python = ["ruff_fix" "ruff_format"];
          rust = ["rustfmt"];
          sh = ["shfmt"];
          sql = ["sqlfluff"];
          css = prettier;
          graphql = prettier;
          html = prettier;
          htmlangular = prettier;
          javascript = prettier;
          javascriptreact = prettier;
          json = prettier;
          markdown = prettier;
          "markdown.mdx" = prettier;
          scss = prettier;
          typescript = prettier;
          typescriptreact = prettier;
          yaml = prettier;
        };
      };
    };
  };

  extraConfigLua = ''
    require("improved-ft").setup({ use_default_mappings = true })
  '';

  keymaps = [
    {
      mode = "n";
      key = "<leader>p";
      action = lib.nixvim.mkRaw "function() require('conform').format({ async = true }) end";
      options = {
        desc = "Format document";
        silent = true;
      };
    }
  ];
}
