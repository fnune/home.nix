{
  pkgs,
  config,
  herdr,
  ...
}:
let
  repos = "${config.home.homeDirectory}/Development/pulumi";
  repo-service = "${repos}/pulumi-service";
  repo-pulumi = "${repos}/pulumi";

  repoWorkspace = label: repo: {
    inherit label;
    focusTab = "git";
    tabs = [
      {
        label = "git";
        root = herdr.pane {
          cwd = repo;
          command = [ "repo-ui" ];
        };
      }
      {
        label = "main";
        root = herdr.pane { cwd = repo; };
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
in
{
  home = {
    packages = [
      work
    ]
    ++ (with pkgs; [
      awscli2
      bubblewrap
      go
      golangci-lint
      golangci-lint-langserver
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
      "${repo-pulumi}/.envrc".source = ./envrc.pulumi.sh;
      "${repo-service}/.envrc.local".source = ./envrc.sh;
      "${repo-service}/CLAUDE.local.md".source = ./CLAUDE.md;
    };

    sessionVariables = {
      GOPATH = "$HOME/.go";
      PATH = "$HOME/.pulumi/bin:$PATH"; # curl -fsSL https://get.pulumi.com | sh
      # Encrypt ~/.pulumi/credentials.json with a key held in the KDE wallet,
      # so a persistent `pulumi login` replaces per-invocation token juggling.
      PULUMI_CREDENTIAL_STORE = "os";
    };
  };

  # `pulumi` targets whichever backend `pulumi login` last selected, normally
  # api.pulumi.com. These reach the other two without disturbing it.
  programs.zsh.shellAliases = {
    pulumi-review = "PULUMI_BACKEND_URL=https://api-fnune-review.review-stacks.pulumi-dev.io pulumi";
    pulumi-local = "PULUMI_BACKEND_URL=http://localhost:8080 pulumi";
  };

  services.flatpak.packages = [
    "com.slack.Slack"
  ];

  programs.git = {
    settings = {
      url = {
        "ssh://git@github.com/pulumi/".insteadOf = "https://github.com/pulumi/";
      };
    };
  };
}
