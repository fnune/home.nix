{ config, pkgs, ... }:

{
  home.username = "nixuser";
  home.homeDirectory = "/home/nixuser";
  home.stateVersion = "23.05";

  home.packages = [
    pkgs.neovim
  ];

  home.file = {
  };

  home.sessionVariables = {
    EDITOR = "nvim";
  };

  programs.home-manager.enable = true;
}
