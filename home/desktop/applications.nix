{pkgs, ...}: {
  nixpkgs = {
    config = {
      allowUnfree = true;
      allowUnfreePredicate = _: true;
    };
  };

  home.packages = with pkgs.unstable; [
    dbeaver-bin
    digikam
    exiftool
    freecad-wayland
    obsidian
    screenkey
    signal-desktop
    spotify
    yubioath-flutter
  ];
}
