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
    haruna
    maestral
    obsidian
    screenkey
    signal-desktop
    spotify
    yubioath-flutter
  ];
}
