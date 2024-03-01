{
  description = "A flake that builds memfaultd natively and can also package it for different targets";
  inputs = {
    rust-overlay.url = "github:oxalica/rust-overlay?rev=72fa0217f76020ad3aeb2dd9dd72490905b23b6f";
    flake-utils.follows = "rust-overlay/flake-utils";
    nixpkgs.follows = "rust-overlay/nixpkgs";
  };
  outputs = inputs:
    inputs.flake-utils.lib.eachDefaultSystem (
      system: let
        pkgs = inputs.nixpkgs.legacyPackages.${system};
        variant = "kirkstone";
        version = "1.10.0-${variant}";
        repo = pkgs.fetchFromGitHub {
          owner = "memfault";
          repo = "memfault-linux-sdk";
          rev = version;
          sha256 = "sha256-siD7uucuYjDBjvl5Q1/I5fZrRaJiZqtLePE3FepvOP8";
        };
        src = "${repo}/meta-memfault/recipes-memfault/memfaultd/files";
        code = pkgs.callPackage ./. {
          inherit (inputs) nixpkgs system rust-overlay;
          inherit version;
          inherit src;
        };
      in rec {
        packages = {
          inherit code;
          all = pkgs.symlinkJoin {
            name = "all";
            paths = with code; [memfaultd];
          };
          default = packages.all;
        };
      }
    );
}
