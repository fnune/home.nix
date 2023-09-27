{ config, pkgs, ... }:

{
  home.username = "fausto";
  home.homeDirectory = "/home/fausto";
  home.stateVersion = "23.05";

  programs.home-manager.enable = true;

  imports = [
    ./programs/zsh.nix
    ./programs/tmux.nix
    ./programs/git.nix
    ./programs/neovim.nix
  ];
}
