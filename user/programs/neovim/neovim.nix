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
      deno
      lua-language-server
      nil
      nodePackages.pyright
      nodePackages.typescript-language-server
      nodePackages.vscode-langservers-extracted
      nodePackages.yaml-language-server
      ruff-lsp
      rustup
      tailwindcss-language-server
      taplo
      # Linters
      alejandra
      luajitPackages.luacheck
      nodePackages.eslint
      nodePackages.eslint_d
      nodePackages.jsonlint
      nodePackages.stylelint
      ruff
      shellcheck
      sqlfluff
      statix
      # Formatters
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
        source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.home.nix/user/programs/neovim/config";
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
