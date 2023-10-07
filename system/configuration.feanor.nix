{...}: {
  imports = [./configuration.nix ./hardware-configuration.feanor.nix];

  networking.hostName = "feanor";
  boot.loader.grub.gfxpayloadEfi = "3840x2160x32";
  boot.plymouth.extraConfig = "DeviceScale=2";
}
