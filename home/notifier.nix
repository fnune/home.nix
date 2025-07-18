{
  pkgs,
  config,
  ...
}: {
  systemd.user = {
    services.nix-update-notifier = {
      Unit = {
        Description = "Check for updates";
        After = ["network-online.target"];
        StartLimitIntervalSec = "24h";
        StartLimitBurst = 5;
      };
      Install.WantedBy = [];
      Service = {
        Type = "oneshot";
        Restart = "on-failure";
        RestartSec = 60;
        Environment = [
          "PATH='${pkgs.git}/bin:${pkgs.openssh}/bin:${pkgs.curl}/bin:${pkgs.gcc}/bin:$PATH'"
          "GIT_SSH_COMMAND='${pkgs.openssh}/bin/ssh -i ${config.home.homeDirectory}/.ssh/id_ed25519'"
          "CC='${pkgs.gcc}/bin/cc'"
        ];
        ExecStart = pkgs.writeShellScript "nix-update-notifier" ''
          echo "Starting update notifier"

          cd ${config.home.homeDirectory}/.home.nix

          current_branch=$(${pkgs.git}/bin/git rev-parse --abbrev-ref HEAD)
          if [ "$current_branch" != "main" ]; then
            echo "Not on main branch, skipping update check"
            exit 0
          fi

          if ! ${pkgs.git}/bin/git fetch origin; then
            echo "Failed to fetch from origin"
            exit 1
          fi

          if ${pkgs.git}/bin/git merge-base --is-ancestor HEAD origin/main; then
            if [ "$(${pkgs.git}/bin/git rev-parse HEAD)" != "$(${pkgs.git}/bin/git rev-parse origin/main)" ]; then
              echo "Local main is behind origin/main, skipping update check"
              exit 0
            fi
          else
            echo "Local main is ahead of or diverged from origin/main"
          fi

          updates_found=false

          echo "Running 'nix flake update nixpkgs'..."
          ${pkgs.nix}/bin/nix flake update nixpkgs &> /dev/null
          if ! ${pkgs.git}/bin/git diff --quiet flake.lock; then
            echo "'nixpkgs' updates found in 'flake.lock'"
            ${pkgs.git}/bin/git add flake.lock
            updates_found=true
          else
            echo "No 'nixpkgs' updates available"
          fi

          echo "Running 'nix flake update'..."
          ${pkgs.nix}/bin/nix flake update &> /dev/null
          if ! ${pkgs.git}/bin/git diff --quiet flake.lock; then
            echo "Additional flake input updates found in 'flake.lock'"
            ${pkgs.git}/bin/git add flake.lock
          else
            echo "No additional flake input updates available"
          fi

          if [ "$updates_found" = "true" ]; then
            ${pkgs.libnotify}/bin/notify-send \
              --app-name="⚙️ System" \
              --icon=nix-snowflake \
              --expire-time=10000 \
              "Updates available" \
              "System updates have been found."
          else
            echo "No updates available"
          fi
        '';
      };
    };
    timers.nix-update-notifier = {
      Unit.Description = "Check for updates periodically";
      Install.WantedBy = ["timers.target"];
      Timer = {
        Unit = "nix-update-notifier.service";
        OnCalendar = "Sat *-*-* 06:00:00";
        Persistent = true;
      };
    };
  };
}
