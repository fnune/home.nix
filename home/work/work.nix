{
  pkgs,
  pkgs-unstable,
  config,
  ...
}: let
  repos = "${config.home.homeDirectory}/Development/pulumi";
  repo-service = "${repos}/pulumi-service";
  repo-pulumi = "${repos}/pulumi";

  herdr = import ../programs/herdr/lib.nix {
    inherit pkgs pkgs-unstable;
    shell = config.shell.bin;
  };

  repoWorkspace = label: repo: {
    inherit label;
    focusTab = "git";
    tabs = [
      {
        label = "git";
        root = herdr.pane {
          cwd = repo;
          command = ["repo-ui"];
        };
      }
      {
        label = "main";
        root = herdr.pane {cwd = repo;};
      }
    ];
  };

  work = herdr.mkProvisioner {
    name = "t";
    focus = "☁️ pulumi/pulumi-service";
    workspaces = [
      (repoWorkspace "☁️ pulumi/pulumi-service" repo-service)
      (repoWorkspace "🔧 pulumi/pulumi" repo-pulumi)
      (repoWorkspace "🔐 pulumi/esc" "${repos}/esc")
      (repoWorkspace "📚 pulumi/docs" "${repos}/docs")
      (repoWorkspace "📦 pulumi/registry" "${repos}/registry")
    ];
  };
in {
  home = {
    packages =
      [work]
      ++ (with pkgs; [
        awscli2
        bubblewrap
        go
        golangci-lint
        golangci-lint-langserver
        gotools
        hugo
        k9s
        kubectl
        lefthook
        mockgen
        mysql84
        ssm-session-manager-plugin
        typescript
        uv
        yarn
      ]);

    file = {
      "${config.home.homeDirectory}/.zsh/includes/t-tmux".source = ./launch.sh;
      "${repo-pulumi}/.envrc".source = ./envrc.pulumi.sh;
      "${repo-service}/.envrc.local".source = ./envrc.sh;
      "${repo-service}/CLAUDE.local.md".source = ./CLAUDE.md;
      "${config.home.homeDirectory}/.local/bin/p" = {
        source = ./p.sh;
        executable = true;
      };
    };

    sessionVariables = {
      GOPATH = "$HOME/.go";
      PATH = "$HOME/.pulumi/bin:$PATH"; # curl -fsSL https://get.pulumi.com | sh
    };
  };

  programs.git = {
    settings = {
      url = {
        "ssh://git@github.com/pulumi/".insteadOf = "https://github.com/pulumi/";
      };
    };
  };
}
