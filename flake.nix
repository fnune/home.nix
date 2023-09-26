{
  description = "Fausto's Home Manager Flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/release-23.05";
    home-manager = {
      url = "github:nix-community/home-manager/release-23.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, home-manager, ... }: {
    defaultPackage.x86_64-linux = home-manager.defaultPackage.x86_64-linux;

    homeConfigurations = {
      "nixuser" = home-manager.lib.homeManagerConfiguration {
        pkgs = import nixpkgs { system = "x86_64-linux"; };
        modules = [ ./home.nix ];
      };
    };
  };
}
