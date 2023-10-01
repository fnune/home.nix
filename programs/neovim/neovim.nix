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
    # Linters
    alejandra
    statix
    # Make :checkhealth happy
    jdk17
    julia
    luajitPackages.luarocks
  ];
  home.file = {
    ".config/nvim/" = {
      source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.home.nix/programs/neovim/config";
    };
  };

  home.sessionVariables.EDITOR = "nvim";
  home.sessionVariables.SUDO_EDITOR = "nvim";
  home.sessionVariables.VISUAL = "nvim";
  programs.git.extraConfig.user.editor = "nvim";
  programs.zsh.shellAliases.vim = "nvim";
}
