{pkgs, ...}: {
  home.packages = with pkgs.unstable; [maestral];
}
