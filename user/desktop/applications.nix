{pkgs, ...}: {
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.allowUnfreePredicate = _: true;

  home.packages = with pkgs.unstable; [
    kdenlive
    lutris
    obsidian
    onlyoffice-bin
    quickemu
    screenkey
    signal-desktop
    spotify
    yubioath-flutter
  ];
}
