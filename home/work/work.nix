{
  pkgs,
  config,
  ...
}: let
  service = "${config.home.homeDirectory}/go/src/github.com/pulumi/pulumi-service";
  awsso = pkgs.callPackage ../../packages/awsso.nix {};
  stablePackages = with pkgs; [
    jetbrains.datagrip
    jetbrains.goland
  ];
in {
  home = {
    packages = with pkgs.unstable;
      [
        _1password-gui
        awscli2
        awsso
        go
        golangci-lint
        golangci-lint-langserver
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
        yarn
        zoom-us
      ]
      ++ stablePackages;

    file = {
      "${config.home.homeDirectory}/.zsh/includes/t".source = ./launch.sh;
      "${service}/.envrc.local".source = ./envrc.sh;
      "${service}/.nvim.lua".source = ./nvim.lua;
    };

    sessionVariables = {
      CYPRESS_INSTALL_BINARY = 0;
      CYPRESS_RUN_BINARY = "${pkgs.unstable.cypress}/bin/Cypress";
    };
  };
}
