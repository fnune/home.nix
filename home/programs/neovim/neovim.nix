{
  pkgs,
  config,
  ...
}: {
  home = {
    packages = with pkgs.unstable; [
      (neovim.overrideAttrs (oldAttrs: {
        # https://github.com/NixOS/nixpkgs/pull/155688
        NIX_LDFLAGS = ["-lstdc++"];
      }))
      # LSPs
      clang-tools
      lua-language-server
      nil
      pyright
      ruff-lsp
      rustup
      tailwindcss-language-server
      taplo
      typescript-language-server
      vscode-langservers-extracted
      yaml-language-server
      # Linters
      alejandra
      eslint
      eslint_d
      luajitPackages.luacheck
      nodePackages.jsonlint
      ruff
      shellcheck
      sqlfluff
      statix
      stylelint
      # Formatters
      biome
      nodePackages.prettier
      nodePackages.sql-formatter
      prettierd
      python3Packages.black
      shfmt
      stylua
      # Debuggers
      python3Packages.debugpy
      # Time tracking
      watson
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
    };
  };
  programs.git.extraConfig.user.editor = "nvim";
  programs.zsh.shellAliases.vim = "nvim";
}
