{pkgs, ...}: {
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.allowUnfreePredicate = _: true;

  home.packages = with pkgs; [
    onlyoffice-bin
    signal-desktop
    slack
    spotify
    ungoogled-chromium
  ];
}
