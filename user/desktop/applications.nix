{pkgs, ...}: {
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.allowUnfreePredicate = _: true;
  nixpkgs.config.permittedInsecurePackages = ["electron-27.3.11"]; # For logseq

  home.packages = with pkgs; [
    haruna
    logseq
    lutris
    obsidian
    screenkey
    signal-desktop
    spotify
    yubioath-flutter
  ];
}
