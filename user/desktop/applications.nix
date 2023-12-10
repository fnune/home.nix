{pkgs, ...}: {
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.allowUnfreePredicate = _: true;

  home.packages = with pkgs; [
    kdenlive
    onlyoffice-bin
    screenkey
    signal-desktop
    slack
    spotify
    vlc
  ];
}
