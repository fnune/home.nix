{pkgs, ...}: {
  nixpkgs = {
    config = {
      allowUnfree = true;
      allowUnfreePredicate = _: true;
    };
  };

  home.packages = with pkgs.unstable; [
    _1password-gui
    bitwarden-desktop
    czkawka-full
    dbeaver-bin
    signal-desktop
    spotify
  ];
}
