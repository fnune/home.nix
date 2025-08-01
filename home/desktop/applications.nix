{pkgs, ...}: {
  home.packages = with pkgs.unstable; [
    bitwarden-desktop
    dbeaver-bin
    podman-desktop
    signal-desktop-bin
    spotify
    yubioath-flutter
  ];
}
