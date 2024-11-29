{pkgs, ...}: {
  nixpkgs = {
    config = {
      allowUnfree = true;
      allowUnfreePredicate = _: true;
    };
  };

  home.packages = with pkgs; [
    digikam
    exiftool
    maestral
    obsidian
    screenkey
    signal-desktop
    spotify
    yubioath-flutter
  ];
}
