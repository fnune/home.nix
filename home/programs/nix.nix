{nixpkgs, ...}: {
  nix.nixPath = ["nixpkgs=${nixpkgs}"];
  nix.registry.nixpkgs.flake = nixpkgs;
}
