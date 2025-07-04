{
  pkgs,
  config,
  ...
}: {
  programs = {
    neovim = {
      enable = true;
      package = pkgs.unstable.neovim-unwrapped;
      extraLuaPackages = ps: [ps.magick];
      extraPackages = [pkgs.imagemagick];
      withNodeJs = true;
      withPython3 = true;
      withRuby = true;
    };
  };

  home = {
    packages = with pkgs.unstable; [
      # LSPs
      angular-language-server
      basedpyright
      clang-tools
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
      # Linters
      alejandra
      eslint
      eslint_d
      go-tools
      luajitPackages.luacheck
      nodePackages.jsonlint
      ruff
      shellcheck
      sqlfluff
      statix
      stylelint
      # Formatters
      biome
      gofumpt
      nodePackages.prettier
      prettierd
      python3Packages.black
      shfmt
      stylua
      # Debuggers
      delve
      python3Packages.debugpy
      # Lower-level tools
      inotify-tools
      nodejs_22
      tree-sitter
    ];

    file = {
      ".config/nvim/" = {
        source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.home.nix/home/programs/neovim/config";
      };
    };

    sessionVariables = {
      EDITOR = "nvim";
      SUDO_EDITOR = "nvim";
      VISUAL = "nvim";
      COLORSCHEME = config.colorscheme;
    };
  };
  programs.git.extraConfig.user.editor = "nvim";
  programs.zsh.shellAliases.vim = "nvim";
}
