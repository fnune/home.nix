{pkgs, ...}: {
  nixpkgs = {
    config = {
      allowUnfree = true;
      allowUnfreePredicate = _: true;
      permittedInsecurePackages = ["electron-27.3.11"]; # For logseq
    };
  };

  home.packages = with pkgs; [
    digikam
    exiftool
    haruna
    logseq
    maestral
    screenkey
    signal-desktop
    spotify
    yubioath-flutter
  ];
}
