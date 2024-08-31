{pkgs, ...}: {
  home.packages = with pkgs.unstable; [gnome-builder flatpak-builder];
}
