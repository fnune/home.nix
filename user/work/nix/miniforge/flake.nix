{
  description = "A flake for Mambaforge";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = {
    self,
    nixpkgs,
    flake-utils,
  }:
    flake-utils.lib.eachDefaultSystem (
      system: let
        pkgs = nixpkgs.legacyPackages.${system};
        mambaforge = import ./default.nix {
          inherit (pkgs) lib fetchurl makeWrapper buildFHSEnv runCommand system;
        };
      in {
        devShells.default = mambaforge.env;
      }
    );
}
