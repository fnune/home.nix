{
  description = "fnune's NixOS configuration files";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/release-23.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/release-23.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    plasma-manager = {
      url = "github:pjones/plasma-manager";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };
    memfaultd.url = "path:user/programs/memfault";
  };

  outputs = {
    self,
    nixpkgs,
    nixpkgs-unstable,
    home-manager,
    plasma-manager,
    memfaultd,
    ...
  }: {
    defaultPackage.x86_64-linux = home-manager.defaultPackage.x86_64-linux;
    nixosConfigurations = let
      makeNixosConfiguration = machineModule:
        nixpkgs.lib.nixosSystem rec {
          system = "x86_64-linux";
          modules = [
            ./system/configuration.nix
            machineModule
            ({
              pkgs,
              lib,
              config,
              ...
            }:
              import ./system/memfaultd.nix {
                inherit pkgs lib config;
                memfaultd = memfaultd.packages.${system}.default;
              })
          ];
        };
    in {
      "feanor" = makeNixosConfiguration ./system/configuration.feanor.nix;
      "melian" = makeNixosConfiguration ./system/configuration.melian.nix;
    };

    homeConfigurations = let
      plasmaManager = plasma-manager.homeManagerModules.plasma-manager;
      unstableOverlay = final: prev: {
        unstable = import nixpkgs-unstable {
          inherit (prev) config;
          system = "x86_64-linux";
        };
      };
      makeHomeConfiguration = machineModule:
        home-manager.lib.homeManagerConfiguration {
          pkgs = import nixpkgs {
            system = "x86_64-linux";
            overlays = [unstableOverlay];
          };
          modules = [
            ./user/home.nix
            plasmaManager
            machineModule
          ];
        };
    in {
      "feanor" = makeHomeConfiguration ./user/home.feanor.nix;
      "melian" = makeHomeConfiguration ./user/home.melian.nix;
    };
  };
}
