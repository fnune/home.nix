{
  description = "fnune's NixOS configuration files";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/release-23.11";
    home-manager = {
      url = "github:nix-community/home-manager";
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
      makeHomeConfiguration = machineModule:
        home-manager.lib.homeManagerConfiguration {
          pkgs = import nixpkgs {system = "x86_64-linux";};
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
