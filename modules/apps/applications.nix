{ pkgs-unstable, ... }:
{
  services.syncthing.enable = true;

  home.packages = with pkgs-unstable; [
    bitwarden-cli
    bitwarden-desktop
    calibre
    darktable
    krita
    obsidian
    podman-desktop
    signal-desktop
    slack
    spotify
  ];
}
