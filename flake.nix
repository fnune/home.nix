{
  description = "fnune's NixOS configuration files";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    plasma-manager = {
      url = "github:pjones/plasma-manager";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };
  };

  outputs = {
    self,
    nixpkgs,
    nixpkgs-unstable,
    home-manager,
    plasma-manager,
    ...
  }: {
    defaultPackage.x86_64-linux = home-manager.defaultPackage.x86_64-linux;
    nixosConfigurations = let
      makeNixosConfiguration = machineModule:
        nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [./system/configuration.nix machineModule];
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
