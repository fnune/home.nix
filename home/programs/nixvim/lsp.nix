{
  pkgs-unstable,
  raw,
  floating_border,
  ...
}: {
  extraPackages = with pkgs-unstable; [
    angular-language-server
    basedpyright
    bash-language-server
    gopls
    lua-language-server
    nil
    pyright
    rustup
    stylelint-lsp
    taplo
    terraform-ls
    typescript-language-server
    vscode-langservers-extracted
    yaml-language-server
  ];

  plugins = {
    lspconfig = {
      enable = true;
    };

    schemastore = {
      enable = true;
    };

    typescript-tools = {
      enable = true;
      settings.expose_as_code_action = "all";
    };

    fidget = {
      enable = true;
    };

    trouble = {
      enable = true;
    };
  };

  lsp.servers = {
    angularls.enable = true;
    biome.enable = true;
    eslint.enable = true;
    gdscript.enable = true;
    golangci_lint_ls.enable = true;
    gopls = {
      enable = true;
      config.settings.gopls.buildFlags = ["-tags=integration"];
    };
    ocamllsp.enable = true;
    ruff.enable = true;
    rust_analyzer.enable = true;
    stylelint_lsp.enable = true;
    taplo.enable = true;
    terraformls.enable = true;
    nil_ls = {
      enable = true;
      config.init_options.nix.flake.autoArchive = true;
    };
    jsonls = {
      enable = true;
      config.init_options.provideFormatter = false;
    };
    basedpyright.enable = true;
    yamlls.enable = true;
    lua_ls = {
      enable = true;
      config.settings.Lua.diagnostics.globals = ["vim"];
    };
    pico8_ls = {
      enable = true;
      package = null;
      config.filetypes = ["p8" "p8lua"];
    };
  };

  extraPlugins = with pkgs-unstable.vimPlugins; [
    live-rename-nvim
    symbol-usage-nvim
  ];

  extraConfigLua = ''
    require("live-rename").setup({})
    require("symbol-usage").setup({ vt_position = "end_of_line", request_pending_text = false })
  '';

  keymaps = [
    {
      mode = "n";
      key = "K";
      action = raw "function() vim.lsp.buf.hover({ max_width = 80 }) end";
      options = {
        desc = "Show documentation";
        silent = true;
      };
    }
    {
      mode = "n";
      key = "<leader>k";
      action = raw "function() vim.diagnostic.goto_prev() end";
      options = {
        desc = "Previous diagnostic";
        silent = true;
      };
    }
    {
      mode = "n";
      key = "<leader>j";
      action = raw "function() vim.diagnostic.goto_next() end";
      options = {
        desc = "Next diagnostic";
        silent = true;
      };
    }
    {
      mode = "n";
      key = "<leader>r";
      action = raw "function() require('live-rename').rename() end";
      options = {
        desc = "Rename symbol";
        silent = true;
      };
    }
    {
      mode = "n";
      key = "gd";
      action = raw "function() require('snacks').picker.lsp_definitions() end";
      options = {
        desc = "Go to definition";
        silent = true;
      };
    }
    {
      mode = "n";
      key = "gD";
      action = raw "function() require('snacks').picker.lsp_declarations() end";
      options = {
        desc = "Go to declaration";
        silent = true;
      };
    }
    {
      mode = "n";
      key = "gi";
      action = raw "function() require('snacks').picker.lsp_implementations() end";
      options = {
        desc = "Go to implementation";
        silent = true;
      };
    }
    {
      mode = "n";
      key = "gT";
      action = raw "function() require('snacks').picker.lsp_type_definitions() end";
      options = {
        desc = "Go to type definition";
        silent = true;
      };
    }
    {
      mode = "n";
      key = "gr";
      action = raw "function() require('snacks').picker.lsp_references() end";
      options = {
        desc = "Show references";
        silent = true;
      };
    }
    {
      mode = ["n" "x"];
      key = "<c-space>";
      action = raw "function() vim.lsp.buf.code_action() end";
      options = {
        desc = "Apply code action";
        silent = true;
      };
    }
    {
      mode = "n";
      key = "<leader>x";
      action = ":Trouble diagnostics<cr>";
      options = {
        desc = "List diagnostics";
        silent = true;
      };
    }
  ];
}
