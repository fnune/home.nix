{...}: {
  imports = [/etc/nixos/hardware-configuration.nix ../../shared/configuration.nix];

  networking.hostName = "feanor";
  boot.loader.grub.gfxpayloadEfi = "3840x2160x32";
}
