{pkgs, ...}: {
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.allowUnfreePredicate = _: true;

  home.packages = with pkgs; [
    kdenlive
    lutris
    onlyoffice-bin
    quickemu
    quickgui
    screenkey
    signal-desktop
    slack
    spotify
    vlc
    yubioath-flutter
  ];
}
