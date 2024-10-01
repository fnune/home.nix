{
  description = "A flake for a Memfault shell environment";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/release-24.05";
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
        shell = import ./default.nix {inherit pkgs;};
      in {
        devShells.default = shell.env;
      }
    );
}
