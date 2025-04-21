{pkgs, ...}: {
  home.packages = with pkgs.unstable; [
    bitwarden-desktop
    dbeaver-bin
    signal-desktop-bin
    spotify
  ];
}
