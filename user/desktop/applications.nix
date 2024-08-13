{pkgs, ...}: {
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.allowUnfreePredicate = _: true;

  home.packages = with pkgs.unstable; [
    ardour
    guitarix
    kdenlive
    libreoffice
    lutris
    obsidian
    quickemu
    screenkey
    signal-desktop
    spotify
    vlc
    yubioath-flutter
  ];
}
