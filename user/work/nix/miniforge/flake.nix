{
  description = "A flake for Mambaforge";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/release-23.11";
    unstable.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = {
    self,
    nixpkgs,
    unstable,
    flake-utils,
  }:
    flake-utils.lib.eachDefaultSystem (
      system: let
        pkgs = nixpkgs.legacyPackages.${system};
        pkgsUnstable = unstable.legacyPackages.${system};
        mambaforge = import ./default.nix {
          inherit (pkgs) lib fetchurl makeWrapper buildFHSEnv runCommand system;
          inherit (pkgsUnstable) playwright-driver;
        };
      in {
        devShells.default = mambaforge.env;
      }
    );
}
