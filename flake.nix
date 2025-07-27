{
  description = "fnune's NixOS configuration files";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/release-25.05";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    plasma-manager = {
      url = "github:pjones/plasma-manager";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };
    nix-flatpak = {
      url = "github:gmodena/nix-flatpak/?ref=latest";
    };
  };

  outputs = {
    nixpkgs,
    home-manager,
    plasma-manager,
    nix-flatpak,
    ...
  }: let
    system = "x86_64-linux";
  in {
    defaultPackage.x86_64-linux = home-manager.defaultPackage.x86_64-linux;

    homeConfigurations = let
      plasmaManager = plasma-manager.homeManagerModules.plasma-manager;
      nixFlatpak = nix-flatpak.homeManagerModules.nix-flatpak;
    in {
      default = home-manager.lib.homeManagerConfiguration {
        pkgs = import nixpkgs {inherit system;};
        modules = [./home/home.nix nixFlatpak plasmaManager];
      };
    };
  };
}
