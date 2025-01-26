{pkgs, ...}: {
  nixpkgs = {
    config = {
      allowUnfree = true;
      allowUnfreePredicate = _: true;
    };
  };

  home.packages = with pkgs; [
    beekeeper-studio
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
