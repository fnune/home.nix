_: {
  home.stateVersion = "26.05";

  services.pacman.packages = [ "kitty-terminfo" ];

  imports = [
    ./base.nix
    ../modules/apps/headless.nix
    ../modules/apps/chrome-display.nix
    ../modules/cli/headless.nix
    ../modules/code/headless.nix
    ../modules/system/headless.nix
    ../modules/work
  ];
}
