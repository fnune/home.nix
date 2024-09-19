{pkgs, ...}: {
  home.packages = with pkgs.unstable; [rustup];
}
