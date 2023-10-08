{pkgs, ...}: {
  networking.hosts."127.0.0.1" = ["minio" "rabbitmq"];

  # Remember to call sudo /var/vanta/vanta-cli register --secret=<secret> --email=<email>
  systemd.services.vanta = {
    enable = true;
    inherit (import ../user/work/nix/vanta {inherit pkgs;}) wantedBy description serviceConfig;
  };

  # Enable greedy file watchers like Vite
  boot.kernel.sysctl = {
    "fs.inotify.max_user_instances" = 1048576;
    "fs.inotify.max_user_watches" = 1048576;
  };
}
