{
  pkgs-unstable,
  customPlugins,
  lib,
  ...
}: {
  extraPackages = with pkgs-unstable; [
    prettier
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
        prettierMarkdown = {
          __unkeyed-1 = "prettier_markdown";
          stop_after_first = true;
        };
      in {
        format_on_save.lsp_format = "fallback";
        default_format_opts.lsp_format = "fallback";

        formatters.prettier_markdown = lib.nixvim.mkRaw ''
          vim.tbl_deep_extend("force", {}, require("conform.formatters.prettier"), {
            prepend_args = { "--tab-width", "4", "--prose-wrap", "never" },
          })
        '';
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
          css = ["biome"];
          graphql = ["biome"];
          javascript = ["biome"];
          javascriptreact = ["biome"];
          json = ["biome"];
          typescript = ["biome"];
          typescriptreact = ["biome"];
          html = prettier;
          htmlangular = prettier;
          markdown = prettierMarkdown;
          "markdown.mdx" = prettierMarkdown;
          scss = prettier;
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
