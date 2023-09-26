{ config, pkgs, ... }:

{
  home.username = "fausto";
  home.homeDirectory = "/home/fausto";
  home.stateVersion = "23.05";

  home.packages = [
    pkgs.neovim
  ];

  home.file = { };

  home.sessionVariables = {
    EDITOR = "nvim";
  };

  programs.home-manager.enable = true;

  imports = [
    ./programs/zsh.nix
    ./programs/tmux.nix
  ];
}
