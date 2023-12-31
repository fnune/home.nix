{
  pkgs,
  config,
  ...
}: {
  home.packages = with pkgs; [
    (neovim.overrideAttrs (oldAttrs: {
      # https://github.com/NixOS/nixpkgs/pull/155688
      NIX_LDFLAGS = ["-lstdc++"];
    }))
    # LSPs
    clang-tools
    lua-language-server
    nil
    nodePackages.pyright
    nodePackages.typescript-language-server
    nodePackages.vscode-langservers-extracted
    nodePackages.yaml-language-server
    ruff-lsp
    rustup
    taplo
    # Linters
    alejandra
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
    nodePackages.prettier_d_slim
    python3Packages.black
    stylua
    # Debuggers
    python3Packages.debugpy
    # Time tracking
    watson
  ];

  home.file = {
    ".config/nvim/" = {
      source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.home.nix/user/programs/neovim/config";
    };
  };

  home.sessionVariables.EDITOR = "nvim";
  home.sessionVariables.SUDO_EDITOR = "nvim";
  home.sessionVariables.VISUAL = "nvim";
  programs.git.extraConfig.user.editor = "nvim";
  programs.zsh.shellAliases.vim = "nvim";
}
