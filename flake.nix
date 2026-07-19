{
  description = "fnune's configuration files";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    plasma-manager = {
      url = "github:pjones/plasma-manager";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };
    standard = {
      url = "github:fnune/standard";
      flake = false;
    };
    nix-flatpak.url = "github:gmodena/nix-flatpak/?ref=latest";
    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    git-hooks = {
      url = "github:cachix/git-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    nixpkgs-unstable,
    home-manager,
    nixvim,
    standard,
    plasma-manager,
    nix-flatpak,
    treefmt-nix,
    git-hooks,
    ...
  }: let
    system = "x86_64-linux";
    pkgs = import nixpkgs {inherit system;};
    pkgs-unstable = import nixpkgs-unstable {
      inherit system;
      config.allowUnfree = true;
    };

    treefmtEval = treefmt-nix.lib.evalModule pkgs ./treefmt.nix;

    vimHerdrNavigation = pkgs.fetchFromGitHub {
      owner = "paulbkim-dev";
      repo = "vim-herdr-navigation";
      rev = "53e318c772c4d3b7fbd904ac43bcf3e5b5d8b244";
      hash = "sha256-vUUt46jiK6ZsPH8D13/+IIlqT3KbFliPJkNplsVqiQo=";
    };

    preCommit = git-hooks.lib.${system}.run {
      src = ./.;
      package = pkgs-unstable.prek;
      hooks = {
        treefmt = {
          enable = true;
          package = treefmtEval.config.build.wrapper;
        };
        shellcheck = {
          enable = true;
          args = ["--severity=warning"];
        };
        deadnix.enable = true;
      };
    };

    nixvimPackage = nixvim.legacyPackages.${system}.makeNixvimWithModule {
      pkgs = pkgs-unstable;
      module = {
        imports = [./home/programs/nixvim/config.nix];
        _module.args = {inherit pkgs-unstable standard vimHerdrNavigation;};
      };
    };
  in {
    packages.${system} = {
      default = home-manager.packages.${system}.default;
      nixvim-test = nixvimPackage;
    };

    formatter.${system} = treefmtEval.config.build.wrapper;

    checks.${system} = {
      formatting = treefmtEval.config.build.check self;
      pre-commit = preCommit;
    };

    devShells.${system}.default = pkgs.mkShell {
      inherit (preCommit) shellHook;
      buildInputs = preCommit.enabledPackages;
    };

    homeConfigurations = let
      plasmaManager = plasma-manager.homeModules.plasma-manager;
      nixFlatpak = nix-flatpak.homeManagerModules.nix-flatpak;
    in {
      fausto = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        extraSpecialArgs = {inherit nixpkgs pkgs-unstable nixvimPackage standard vimHerdrNavigation;};
        modules = [./home/home.nix nixFlatpak plasmaManager];
      };
    };
  };
}
