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
      };
      Install.WantedBy = ["default.target"];
      Service = {
        Type = "oneshot";
        Environment = "PATH=$PATH:${pkgs.openssh}/bin";
        ExecStart = pkgs.writeShellScript "nix-update-notifier" ''
          echo "Starting update notifier"

          cd ${config.home.homeDirectory}/.home.nix

          current_branch=$(${pkgs.git}/bin/git rev-parse --abbrev-ref HEAD)
          if [ "$current_branch" != "main" ]; then
            echo "Not on main branch, skipping update check"
            exit 0
          fi

          ${pkgs.git}/bin/git fetch origin
          local_commit=$(${pkgs.git}/bin/git rev-parse HEAD)
          remote_commit=$(${pkgs.git}/bin/git rev-parse origin/main)
          if [ "$local_commit" != "$remote_commit" ]; then
            echo "Local main is not up to date with origin/main, skipping update check"
            exit 0
          else
            echo "Local main is up to date with origin/main"
          fi

          echo "Running 'nix flake update'..."
          ${pkgs.nix}/bin/nix flake update &> /dev/null

          if ! ${pkgs.git}/bin/git diff --quiet flake.lock; then
            echo "Updates found in 'flake.lock'"
            ${pkgs.libnotify}/bin/notify-send \
              --app-name="⚙️ System" \
              --icon=nix-snowflake \
              --expire-time=10000 \
              "Updates available" \
              "There are new input hashes available for your system flake."

            echo "Staging 'flake.lock' changes"
            ${pkgs.git}/bin/git add flake.lock
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
        OnStartupSec = "10s";
        OnUnitActiveSec = 600;
        Unit = "nix-update-notifier.service";
      };
    };
  };
}
