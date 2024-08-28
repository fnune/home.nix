{pkgs, ...}: {
  home.packages = with pkgs.unstable; [gnome-chess stockfish];
}
