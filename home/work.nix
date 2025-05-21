{
  pkgs,
  config,
  ...
}: let
  service = "${config.home.homeDirectory}/go/src/github.com/pulumi/pulumi-service";
in {
  home = {
    packages = with pkgs.unstable; [
      _1password-gui
      awscli2
      go
      golangci-lint
      golangci-lint-langserver
      gotools
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
