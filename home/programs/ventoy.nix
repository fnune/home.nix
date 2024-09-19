{pkgs, ...}: {
  home.packages = with pkgs.unstable; [ventoy-full];
}
