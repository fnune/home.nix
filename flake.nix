{
  description = "Fausto's Home Manager Flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/release-23.05";
    home-manager = {
      url = "github:nix-community/home-manager/release-23.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    plasma-manager.url = "github:pjones/plasma-manager";
    plasma-manager.inputs.nixpkgs.follows = "nixpkgs";
    plasma-manager.inputs.home-manager.follows = "home-manager";
  };

  outputs = {
    nixpkgs,
    home-manager,
    plasma-manager,
    self,
    ...
  }: {
    defaultPackage.x86_64-linux = home-manager.defaultPackage.x86_64-linux;

    homeConfigurations = {
      "fausto" = home-manager.lib.homeManagerConfiguration {
        pkgs = import nixpkgs {system = "x86_64-linux";};
        modules = [
          ./home.nix
          plasma-manager.homeManagerModules.plasma-manager
          {
            home.activation.setupConfig = home-manager.lib.hm.dag.entryAfter ["writeBoundary"] ''
              mkdir -p $HOME/.config/{home-manager,nix}
              ln -sf ${self}/home.nix $HOME/.config/home-manager/home.nix
              ln -sf ${self}/nix.conf $HOME/.config/nix/nix.conf
            '';
          }
        ];
      };
    };
  };
}
