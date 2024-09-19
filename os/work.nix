{pkgs, ...}: {
  networking.hosts."127.0.0.1" = ["minio" "rabbitmq"];

  # Remember to call sudo /var/vanta/vanta-cli register --secret=<secret> --email=<email>
  systemd.services.vanta = {
    enable = true;
    inherit (import ../home/work/nix/vanta {inherit pkgs;}) wantedBy description serviceConfig;
  };

  # Enable greedy file watchers like Vite
  boot.kernel.sysctl = {
    "fs.inotify.max_user_instances" = 2097152;
    "fs.inotify.max_user_watches" = 2097152;
  };

  environment.systemPackages = [pkgs.cloudflare-warp];
  systemd.packages = [pkgs.cloudflare-warp];
  systemd.targets.multi-user.wants = ["warp-svc.service"];
  systemd.user.services.warp-taskbar.enable = false;
  systemd.user.services."app-com.cloudflare.WarpTaskbar@autostart".enable = false;
}
