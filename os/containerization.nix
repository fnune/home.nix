{pkgs, ...}: {
  users.users.fausto.extraGroups = ["docker"];

  virtualisation.docker.enable = true;

  environment.systemPackages = with pkgs; [docker-compose lazydocker];
}
