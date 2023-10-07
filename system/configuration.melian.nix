{...}: {
  imports = [./configuration.nix ./hardware-configuration.melian.nix];

  networking.hostName = "melian";
  boot.loader.grub.gfxpayloadEfi = "1920x1200x32";
}
