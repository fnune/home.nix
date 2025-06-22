{pkgs, ...}: {
  virtualisation.libvirtd.enable = true;

  users.users.fausto.extraGroups = ["libvirtd"];

  environment.systemPackages = with pkgs; [gnome-boxes];
}
