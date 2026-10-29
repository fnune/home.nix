{
  pkgs,
  lib,
  config,
  ...
}:
let
  gitObjectId = "^[0-9a-f]{40}$";

  neverCredentialStores = [
    "/node_modules/"
    "/\\.git/"
    "/containers/storage/"
    "/\\.cache/doriath/.+/(go|\\.cache|\\.local)/"
    "/go-build[0-9]+/"
    "/\\.claude/sessions/[^/]+\\.key$"
  ];

  betterleaksConfig = (pkgs.formats.toml { }).generate "secret-scan-betterleaks.toml" {
    extend.useDefault = true;
    allowlists = [
      { paths = neverCredentialStores; }
      {
        regexTarget = "secret";
        regexes = [ gitObjectId ];
      }
      {
        targetRules = [ "generic-api-key" ];
        condition = "AND";
        paths = [ "/\\.claude/projects/" ];
        regexTarget = "match";
        regexes = [ "(?i)^password_(hash|salt) *= *'[0-9a-f]{32,128}'$" ];
      }
    ];
  };

  settings = pkgs.writeText "secret-scan-settings.json" (
    builtins.toJSON {
      state_dir = "${config.xdg.stateHome}/secret-scan";
      credential_locations = [
        ".aws"
        ".cache/doriath"
        ".claude"
        ".codex"
        ".config"
        ".docker"
        ".gnupg"
        ".kube"
        ".local/state/doriath"
        ".pulumi/credentials.json"
        ".ssh"
      ];
      betterleaks = lib.getExe pkgs.betterleaks;
      betterleaks_config = betterleaksConfig;
      trufflehog = lib.getExe pkgs.trufflehog;
      trufflehog_detectors = [
        "AWS"
        "AWSSessionKey"
        "Anthropic"
        "CloudflareApiToken"
        "CloudflareCaKey"
        "DatadogToken"
        "Dockerhub"
        "GCP"
        "GCPApplicationDefaultCredentials"
        "Github"
        "GitHubOauth2"
        "GoogleGeminiAPIKey"
        "GoogleOauth2"
        "HuggingFace"
        "JDBC"
        "LaunchDarkly"
        "LinearAPI"
        "MongoDB"
        "Notion"
        "NpmToken"
        "OpenAI"
        "Postgres"
        "PrivateKey"
        "Pulumi"
        "SentryToken"
        "Slack"
        "SlackWebhook"
        "Tailscale"
        "URI"
      ];
      trufflehog_ignored_secret = gitObjectId;
      trufflehog_excludes = pkgs.writeText "secret-scan-trufflehog-excludes" (
        lib.concatLines neverCredentialStores
      );
      notify_send = lib.getExe' pkgs.libnotify "notify-send";
    }
  );

  python = pkgs.python3;

  secretScan =
    pkgs.runCommand "secret-scan"
      {
        src = pkgs.replaceVars ./secret_scan.py { inherit settings; };
        nativeBuildInputs = [
          pkgs.basedpyright
          pkgs.ruff
        ];
        meta.mainProgram = "secret-scan";
      }
      ''
        cp $src secret_scan.py
        basedpyright --warnings --pythonpath ${python.interpreter} secret_scan.py
        ruff check --no-cache secret_scan.py
        mkdir -p $out/bin
        { echo "#!${python.interpreter} -I"; cat secret_scan.py; } >$out/bin/secret-scan
        chmod +x $out/bin/secret-scan
      '';
in
{
  home.packages = [ secretScan ];

  systemd.user = {
    services.secret-scan = {
      Unit.Description = "Redacted secret scan of agent transcripts and credential stores";
      Service = {
        Type = "oneshot";
        ExecStart = lib.getExe secretScan;
        Nice = 19;
        IOSchedulingClass = "idle";
      };
    };
    timers.secret-scan = {
      Unit.Description = "Daily redacted secret scan";
      Timer = {
        OnCalendar = "daily";
        Persistent = true;
        RandomizedDelaySec = "1h";
      };
      Install.WantedBy = [ "timers.target" ];
    };
  };
}
