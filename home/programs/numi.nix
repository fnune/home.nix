{pkgs, ...}: {
  home.packages = [(pkgs.callPackage ../../packages/numi.nix {})];
}
