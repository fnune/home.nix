{pkgs, ...}: {
  users.users.fausto.extraGroups = ["docker" "libvirtd"];

  virtualisation = {
    docker.enable = true;
    libvirtd.enable = true;
    podman = {
      enable = true;
      dockerCompat = true;
    };
  };

  environment.systemPackages = with pkgs; [
    distrobox
    docker-compose
    gnome-boxes
    lazydocker
  ];
}
