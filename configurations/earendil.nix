{ pkgs, ... }:
{
  home.stateVersion = "26.05";

  home.file.".terminfo".source = "${pkgs.kitty.terminfo}/share/terminfo";

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
