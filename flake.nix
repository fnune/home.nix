{
  description = "fnune's NixOS configuration files";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nixpkgs-development.url = "github:fnune/nixpkgs/pinentry-kwallet";
    tuxedo-nixos.url = "github:sund3RRR/tuxedo-nixos";
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
    system-manager = {
      url = "github:numtide/system-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-flatpak = {
      url = "github:gmodena/nix-flatpak/?ref=latest";
    };
  };

  outputs = {
    nixpkgs,
    nixpkgs-unstable,
    nixpkgs-development,
    home-manager,
    plasma-manager,
    nur,
    tuxedo-nixos,
    system-manager,
    nix-flatpak,
    ...
  }: let
    system = "x86_64-linux";
    nixpkgsOverlay = final: prev: {
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
      makeNixosConfiguration = modules:
        nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [./os/configuration.nix nixpkgsOverlayModule] ++ modules;
        };
    in {
      "feanor" = makeNixosConfiguration [./os/configuration.feanor.nix];
      "melian" = makeNixosConfiguration [./os/configuration.melian.nix tuxedo-nixos.nixosModules.default];
    };

    systemConfigs.default = system-manager.lib.makeSystemConfig {
      modules = [./os/configuration.debian.nix];
    };

    homeConfigurations = let
      plasmaManager = plasma-manager.homeManagerModules.plasma-manager;
      nixFlatpak = nix-flatpak.homeManagerModules.nix-flatpak;
      makeHomeConfiguration = machineModule:
        home-manager.lib.homeManagerConfiguration {
          pkgs = import nixpkgs {
            inherit system;
            overlays = [nixpkgsOverlay];
          };
          modules = [
            ./home/home.nix
            nixFlatpak
            plasmaManager
            machineModule
          ];
        };
    in {
      "fausto@feanor" = makeHomeConfiguration ./home/home.feanor.nix;
      "fausto@melian" = makeHomeConfiguration ./home/home.melian.nix;
      "fausto@debian" = makeHomeConfiguration ./home/home.debian.nix;
    };
  };
}
