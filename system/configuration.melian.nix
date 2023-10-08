{...}: {
  imports = [./configuration.nix ./hardware-configuration.melian.nix];

  networking.hostName = "melian";
  services.tlp.enable = true;
  boot.loader.timeout = 0;
  boot.loader.systemd-boot.enable = true;
}
