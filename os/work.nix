{pkgs, ...}: {
  networking = {
    hosts."127.0.0.1" = ["minio" "rabbitmq" "virtual-sql.test"];
    firewall.allowedTCPPorts = [8000];
  };

  systemd = {
    services.vanta = {
      # Remember to call sudo /var/vanta/vanta-cli register --secret=<secret> --email=<email>
      enable = true;
      inherit (import ../packages/vanta.nix {inherit pkgs;}) wantedBy description serviceConfig;
    };
    packages = [pkgs.cloudflare-warp];
    targets.multi-user.wants = ["warp-svc.service"];
    user = {
      services = {
        warp-taskbar.enable = false;
        "app-com.cloudflare.WarpTaskbar@autostart".enable = false;
      };
    };
  };

  # Enable greedy file watchers like Vite
  boot.kernel.sysctl = {
    "fs.inotify.max_user_instances" = 2097152;
    "fs.inotify.max_user_watches" = 2097152;
  };

  environment.systemPackages = [pkgs.cloudflare-warp];
}
