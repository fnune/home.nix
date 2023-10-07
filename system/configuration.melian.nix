{...}: {
  imports = [./configuration.nix ./hardware-configuration.melian.nix];

  networking.hostName = "melian";
  boot.loader.timeout = 0;
  boot.loader.systemd-boot.enable = true;
}
