{pkgs, ...}: {
  home.packages = with pkgs.unstable; [
    _1password-gui
    bitwarden-desktop
    dbeaver-bin
    signal-desktop-bin
    spotify
  ];
}
