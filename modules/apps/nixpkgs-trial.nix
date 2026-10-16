# Nixpkgs builds of programs still installed through pacman, shadowing them in
# PATH while each one is validated. The app menu still launches the pacman copy.
{ pkgs-unstable, ... }:
{
  home.packages = with pkgs-unstable; [
    calibre
    chromium
    godot
    libreoffice-qt-fresh
    pdfarranger
    podman-desktop
    (reaper.override { jackLibrary = pipewire.jack; })
    signal-desktop
  ];
}
