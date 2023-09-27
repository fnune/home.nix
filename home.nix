{ config, pkgs, ... }:

{
  home.username = "fausto";
  home.homeDirectory = "/home/fausto";
  home.stateVersion = "23.05";

  programs.home-manager.enable = true;

  imports = [
    ./programs/editorconfig.nix
    ./programs/git.nix
    ./programs/neovim/neovim.nix
    ./programs/tmux/tmux.nix
    ./programs/zsh.nix
  ];
}
