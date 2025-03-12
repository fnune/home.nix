{
  description = "fnune's NixOS configuration files";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-previous.url = "github:nixos/nixpkgs/nixos-24.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nixpkgs-development.url = "github:fnune/nixpkgs/fnune/testing";
    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    plasma-manager = {
      url = "github:pjones/plasma-manager";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };
  };

  outputs = {
    nixpkgs,
    nixpkgs-previous,
    nixpkgs-unstable,
    nixpkgs-development,
    home-manager,
    plasma-manager,
    nur,
    ...
  }: let
    system = "x86_64-linux";
    nixpkgsOverlay = final: prev: {
      previous = import nixpkgs-previous {
        inherit (prev) config;
        inherit system;
      };
      unstable = import nixpkgs-unstable {
        inherit (prev) config;
        inherit system;
      };
      development = import nixpkgs-development {
        inherit (prev) config;
        inherit system;
      };
      nur = import nur {
        nurpkgs = prev;
        pkgs = prev;
      };
    };
    nixpkgsOverlayModule = _: {nixpkgs.overlays = [nixpkgsOverlay];};
  in {
    defaultPackage.x86_64-linux = home-manager.defaultPackage.x86_64-linux;
    nixosConfigurations = let
      makeNixosConfiguration = machineModule:
        nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [./os/configuration.nix machineModule nixpkgsOverlayModule];
        };
    in {
      "feanor" = makeNixosConfiguration ./os/configuration.feanor.nix;
      "melian" = makeNixosConfiguration ./os/configuration.melian.nix;
    };

    homeConfigurations = let
      plasmaManager = plasma-manager.homeManagerModules.plasma-manager;
      makeHomeConfiguration = machineModule:
        home-manager.lib.homeManagerConfiguration {
          pkgs = import nixpkgs {
            inherit system;
            overlays = [nixpkgsOverlay];
          };
          modules = [
            ./home/home.nix
            plasmaManager
            machineModule
          ];
        };
    in {
      "fausto@feanor" = makeHomeConfiguration ./home/home.feanor.nix;
      "fausto@melian" = makeHomeConfiguration ./home/home.melian.nix;
    };
  };
}
