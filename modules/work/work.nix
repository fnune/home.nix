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
      aws-vault
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
      ".aws/sso/cache".text =
        "Blocks plaintext SSO tokens: use aws-vault, which keeps them in the keyring.\n";
      "${repo-pulumi}/.envrc".source = ./envrc.pulumi.sh;
      "${repo-service}/.envrc.local".source = ./envrc.sh;
      "${repo-service}/CLAUDE.local.md".source = ./CLAUDE.md;
    };

    sessionVariables = {
      GOPATH = "$HOME/.go";
      # Encrypt ~/.pulumi/credentials.json with a key held in the KDE wallet,
      # so a persistent `pulumi login` replaces per-invocation token juggling.
      PULUMI_CREDENTIAL_STORE = "os";
      AWS_VAULT_BACKEND = "secret-service";
    };
  };

  # `pulumi` targets whichever backend `pulumi login` last selected, normally
  # api.pulumi.com. These reach the others without disturbing it.
  programs.zsh.shellAliases = {
    pulumi-ops = "PULUMI_BACKEND_URL=https://api.ops.pulumi.com pulumi";
    pulumi-review = "PULUMI_BACKEND_URL=https://api-fnune-review.review-stacks.pulumi-dev.io pulumi";
    pulumi-local = "PULUMI_BACKEND_URL=http://localhost:8080 pulumi";
  };

  # Repositories that pin a version, like pulumi-service's .pulumi-version, override this.
  programs.mise.globalConfig.tools.pulumi = "latest";

  programs.git = {
    settings = {
      url = {
        "ssh://git@github.com/pulumi/".insteadOf = "https://github.com/pulumi/";
      };
    };
  };
}
