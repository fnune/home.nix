{pkgs, ...}: {
  home.packages = with pkgs.unstable; [rpi-imager];
}
