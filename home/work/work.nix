{
  pkgs,
  config,
  ...
}: let
  repos = "${config.home.homeDirectory}/Development/pulumi";
  repo-service = "${repos}/pulumi-service";
  repo-pulumi = "${repos}/pulumi";
in {
  home = {
    packages = with pkgs; [
      awscli2
      go
      golangci-lint
      golangci-lint-langserver
      gotools
      hugo
      k9s
      kubectl
      lefthook
      mockgen
      mysql80
      typescript
      uv
      yarn
    ];

    file = {
      "${config.home.homeDirectory}/.zsh/includes/t".source = ./launch.sh;
      "${repo-pulumi}/.envrc".source = ./envrc.pulumi.sh;
      "${repo-service}/.envrc.local".source = ./envrc.sh;
      "${repo-service}/CLAUDE.local.md".source = ./CLAUDE.md;
    };

    sessionVariables = {
      GOPATH = "$HOME/.go";
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
