{pkgs, ...}: {
  home.packages = with pkgs.unstable; [gnome.gnome-chess stockfish];
}
