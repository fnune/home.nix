{
  description = "fnune's NixOS configuration files";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nixpkgs-development.url = "github:fnune/nixpkgs/fix-gemini-cli-collisions";
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
    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };
  };

  outputs = {
    nixpkgs,
    nixpkgs-unstable,
    nixpkgs-development,
    home-manager,
    plasma-manager,
    zen-browser,
    nur,
    tuxedo-nixos,
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

    homeConfigurations = let
      plasmaManager = plasma-manager.homeManagerModules.plasma-manager;
      zenBrowser = zen-browser.homeModules.beta;
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
            zenBrowser
          ];
        };
    in {
      "fausto@feanor" = makeHomeConfiguration ./home/home.feanor.nix;
      "fausto@melian" = makeHomeConfiguration ./home/home.melian.nix;
    };
  };
}
