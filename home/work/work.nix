{
  pkgs,
  config,
  ...
}: let
  src = "${config.home.homeDirectory}/go/src/github.com/pulumi";
  src-service = "${src}/pulumi-service";
  awsso = pkgs.callPackage ../../packages/awsso.nix {};
in {
  home = {
    packages = with pkgs.unstable; [
      _1password-gui
      awscli2
      awsso
      go
      golangci-lint
      golangci-lint-langserver
      google-chrome
      gotools
      k9s
      kubectl
      lefthook
      mockgen
      mysql80
      pulumi
      pulumi-esc
      pulumiPackages.pulumi-nodejs
      pulumictl
      slack
      uv
      yarn
      zoom-us
    ];

    file = {
      "${config.home.homeDirectory}/.zsh/includes/t".source = ./launch.sh;
      "${src-service}/.envrc.local".source = ./envrc.sh;
      "${src-service}/CLAUDE.local.md".source = ./CLAUDE.md;
    };
  };

  programs.git = {
    extraConfig = {
      url = {
        "ssh://git@github.com/pulumi/".insteadOf = "https://github.com/pulumi/";
      };
    };
  };
}
