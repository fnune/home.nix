{
  pkgs,
  config,
  ...
}: let
  src = "${config.home.homeDirectory}/go/src/github.com/pulumi";
  src-service = "${src}/pulumi-service";
  src-oss = "${src}/pulumi";
in {
  home = {
    packages = with pkgs.unstable; [
      awscli2
      go
      golangci-lint
      golangci-lint-langserver
      gotools
      k9s
      kubectl
      lefthook
      mockgen
      mysql80
      pulumi-esc
      typescript
      uv
      yarn
    ];

    file = {
      "${config.home.homeDirectory}/.zsh/includes/t".source = ./launch.sh;
      "${src-oss}/.envrc".source = ./envrc.oss.sh;
      "${src-service}/.envrc.local".source = ./envrc.sh;
      "${src-service}/CLAUDE.local.md".source = ./CLAUDE.md;
    };

    sessionVariables = {
      PATH = "$HOME/.pulumi/bin:$PATH"; # curl -fsSL https://get.pulumi.com | sh
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
