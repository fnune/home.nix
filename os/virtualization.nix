{pkgs, ...}: {
  users.users.fausto.extraGroups = ["docker" "libvirtd"];

  virtualisation = {
    docker.enable = true;
    podman.enable = true;
    libvirtd.enable = true;
  };

  environment.systemPackages = with pkgs; [
    distrobox
    docker-compose
    gnome-boxes
    lazydocker
  ];
}
