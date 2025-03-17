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

          if ${pkgs.git}/bin/git merge-base --is-ancestor HEAD origin/main; then
            if [ "$(${pkgs.git}/bin/git rev-parse HEAD)" != "$(${pkgs.git}/bin/git rev-parse origin/main)" ]; then
              echo "Local main is behind origin/main, skipping update check"
              exit 0
            fi
          else
            echo "Local main is ahead of or diverged from origin/main"
          fi

          updates_found=false

          echo "Running 'nix flake update'..."
          ${pkgs.nix}/bin/nix flake update &> /dev/null
          if ! ${pkgs.git}/bin/git diff --quiet flake.lock; then
            echo "Updates found in 'flake.lock'"
            echo "Staging 'flake.lock' changes"
            ${pkgs.git}/bin/git add flake.lock
            updates_found=true
          else
            echo "No nix updates available"
          fi

          echo "Checking for Neovim plugin updates with lazy.nvim..."
          LAZY_LOCK="${config.home.homeDirectory}/.home.nix/home/programs/neovim/config/lazy-lock.json"

          ${pkgs.neovim}/bin/nvim --headless "+Lazy! update" +qa
          echo "lazy.nvim update completed"

          if ! ${pkgs.git}/bin/git diff --quiet "$LAZY_LOCK"; then
            echo "Updates found in lazy-lock.json"
            echo "Staging 'lazy-lock.json' changes"
            ${pkgs.git}/bin/git add "$LAZY_LOCK"
            updates_found=true
          else
            echo "No Neovim plugin updates available"
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
