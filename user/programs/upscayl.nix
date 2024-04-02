{pkgs, ...}: {
  home.packages = with pkgs.unstable; [upscayl];
}
