{
  pkgs,
  lib,
  config,
  herdr,
  ...
}:
let
  repos = "${config.home.homeDirectory}/Development/pulumi";
  repo-service = "${repos}/pulumi-service";
  repo-pulumi = "${repos}/pulumi";

  pulumiBackends = {
    ops = "https://api.ops.pulumi.com";
    eu = "https://api.eu.pulumi.com";
    review = "https://api-fnune-review.review-stacks.pulumi-dev.io";
    local = "http://localhost:8080";
  };
  pulumiHome = name: "${config.home.homeDirectory}/.pulumi-${name}";

  pluginsSharedWithDefaultPulumiHome = lib.mapAttrs' (
    name: _:
    lib.nameValuePair "${pulumiHome name}/plugins" {
      source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.pulumi/plugins";
    }
  ) pulumiBackends;

  pulumiAliasesWithOwnLogin = lib.mapAttrs' (
    name: url:
    lib.nameValuePair "pulumi-${name}" "PULUMI_HOME=${pulumiHome name} PULUMI_BACKEND_URL=${url} pulumi"
  ) pulumiBackends;

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
    }
    // pluginsSharedWithDefaultPulumiHome;

    sessionVariables = {
      GOPATH = "$HOME/.go";
      # Encrypt ~/.pulumi/credentials.json with a key held in the KDE wallet,
      # so a persistent `pulumi login` replaces per-invocation token juggling.
      PULUMI_CREDENTIAL_STORE = "os";
      AWS_VAULT_BACKEND = "secret-service";
    };
  };

  programs.zsh.shellAliases = pulumiAliasesWithOwnLogin // {
    tunnel-preset = "PULUMI_HOME=${pulumiHome "ops"} ${repo-service}/scripts/dev/tunnel-preset.sh";
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
