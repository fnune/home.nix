{pkgs, ...}: {
  home.packages = [(pkgs.callPackage ../../packages/tableplus.nix {})];
}
