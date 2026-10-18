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
    clack = {
      url = "github:fnune/clack/v0.2.3";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    system-manager = {
      url = "github:numtide/system-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    git-hooks = {
      url = "github:cachix/git-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      nixpkgs-unstable,
      home-manager,
      nixvim,
      standard,
      plasma-manager,
      clack,
      system-manager,
      treefmt-nix,
      git-hooks,
      ...
    }:
    let
      system = "x86_64-linux";
      username = "fausto";
      pkgs = import nixpkgs { inherit system; };
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
            args = [ "--severity=warning" ];
          };
          deadnix.enable = true;
          typos = {
            enable = true;
            excludes = [ "flake.lock" ];
            settings.config.default.extend-ignore-re = [ "<leader>[a-zA-Z]+" ];
          };
        };
      };

      nixvimPackage = nixvim.legacyPackages.${system}.makeNixvimWithModule {
        pkgs = pkgs-unstable;
        module = {
          imports = [ ./modules/code/nixvim/config.nix ];
          _module.args = {
            inherit
              pkgs-unstable
              standard
              vimHerdrNavigation
              username
              ;
          };
        };
      };
    in
    {
      packages.${system} = {
        default = home-manager.packages.${system}.default;
        nixvim-test = nixvimPackage;
        system-manager = system-manager.packages.${system}.default;
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

      homeConfigurations =
        let
          mkHome =
            modules:
            home-manager.lib.homeManagerConfiguration {
              inherit pkgs modules;
              extraSpecialArgs = {
                inherit
                  nixpkgs
                  pkgs-unstable
                  nixvimPackage
                  standard
                  vimHerdrNavigation
                  username
                  ;
              };
            };
        in
        {
          ${username} = mkHome [
            ./configurations/all.nix
            plasma-manager.homeModules.plasma-manager
            clack.homeManagerModules.default
          ];
          "${username}@earendil" = mkHome [ ./configurations/earendil.nix ];
        };

      systemConfigs =
        nixpkgs.lib.genAttrs
          [
            "earendil"
            "feanor"
            "melian"
          ]
          (
            host:
            let
              home = self.homeConfigurations.${if host == "earendil" then "${username}@earendil" else username};
            in
            system-manager.lib.makeSystemConfig {
              extraSpecialArgs = {
                inherit clack;
                gpuDrivers = home.config.targets.genericLinux.gpu.drivers;
              };
              modules = [
                {
                  nixpkgs.hostPlatform = system;
                  system-manager.allowAnyDistro = true;
                }
                ./systems/${host}.nix
              ];
            }
          );
    };
}
