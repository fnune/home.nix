{pkgs, ...}: {
  home.packages = with pkgs.unstable.jetbrains; [datagrip];
}
