{
  pkgs,
  lib,
  config,
  ...
}:
let
  settings = pkgs.writeText "secret-scan-settings.json" (
    builtins.toJSON {
      state_dir = "${config.xdg.stateHome}/secret-scan";
      transcripts = [
        ".claude/projects"
        ".codex/sessions"
        ".cache/doriath/agents/*/home/.claude/projects"
        ".cache/doriath/agents/*/home/.codex/sessions"
      ];
      unexpected_credential_files = [
        ".aws/credentials"
        ".azure/accessTokens.json"
        ".azure/msal_token_cache.json"
        ".boto"
        ".cargo/credentials"
        ".cargo/credentials.toml"
        ".circleci/cli.yml"
        ".cloudflared/cert.pem"
        ".composer/auth.json"
        ".config/composer/auth.json"
        ".config/configstore/firebase-tools.json"
        ".config/doctl/config.yaml"
        ".config/gcloud/application_default_credentials.json"
        ".config/gcloud/credentials.db"
        ".config/git/credentials"
        ".config/glab-cli/config.yml"
        ".config/hcloud/cli.toml"
        ".config/hub"
        ".config/linode-cli"
        ".config/netlify/config.json"
        ".config/ngrok/ngrok.yml"
        ".config/rclone/rclone.conf"
        ".config/stripe/config.toml"
        ".databrickscfg"
        ".fly/config.yml"
        ".gem/credentials"
        ".git-credentials"
        ".gradle/gradle.properties"
        ".huggingface/token"
        ".cache/huggingface/token"
        ".kaggle/kaggle.json"
        ".local/share/com.vercel.cli/auth.json"
        ".m2/settings-security.xml"
        ".my.cnf"
        ".netrc"
        ".oci/config"
        ".pgpass"
        ".pypirc"
        ".railway/config.json"
        ".s3cfg"
        ".sentryclirc"
        ".snowflake/connections.toml"
        ".supabase/access-token"
        ".terraform.d/credentials.tfrc.json"
        ".terraformrc"
        ".twilio-cli/config.json"
        ".vault-token"
        ".wrangler/config/default.toml"
      ];
      plaintext_credential_patterns = {
        ".aws/config" = "^\\s*aws_(access_key_id|secret_access_key|session_token)\\s*=";
        ".config/gh/hosts.yml" = "^\\s*oauth_token:";
        ".docker/config.json" = "\"(auth|identitytoken)\"\\s*:\\s*\"[^\"]";
        ".kube/config" = "^\\s*(token|client-key-data|password):";
        ".npmrc" = "^[^#;]*(_authToken|_auth|_password)\\s*=\\s*[^$\\s]";
        ".pulumi/credentials.json" = "pul-[0-9a-f]{40}";
      };
      trufflehog = lib.getExe pkgs.trufflehog;
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
      Unit.Description = "Redacted scan of agent transcripts and credential stores";
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
