_: {
  home.stateVersion = "25.05";

  imports = [
    ./base.nix
    ../modules/apps
    ../modules/cli
    ../modules/code
    ../modules/desktop
    ../modules/system
    ../modules/work
  ];
}
