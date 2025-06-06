{
  pkgs,
  config,
  ...
}: let
  service = "${config.home.homeDirectory}/go/src/github.com/pulumi/pulumi-service";
  awsso = pkgs.callPackage ../packages/awsso.nix {};
in {
  home = {
    packages = with pkgs.unstable; [
      _1password-gui
      awscli2
      awsso
      go
      golangci-lint
      golangci-lint-langserver
      gotools
      jetbrains.datagrip
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
    ];

    file."${service}/.nvim.lua".source = ./work.lua;
    file."${service}/.envrc.local".source = ./work.envrc;

    sessionVariables = {
      CYPRESS_INSTALL_BINARY = 0;
      CYPRESS_RUN_BINARY = "${pkgs.unstable.cypress}/bin/Cypress";
    };
  };
}
