{...}: {
  imports = [./configuration.nix];

  networking.hostName = "melian";
  boot.loader.grub.gfxpayloadEfi = "1920x1200x32";
}
