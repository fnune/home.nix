{pkgs, ...}: {
  imports = [./configuration.nix ./hardware-configuration.feanor.nix];

  networking.hostName = "feanor";

  # Dual boot
  environment.systemPackages = [pkgs.os-prober];
  boot.loader.grub = {
    enable = true;
    device = "nodev";
    efiInstallAsRemovable = true;
    efiSupport = true;
    gfxmodeEfi = "auto";
    useOSProber = true;
    gfxpayloadEfi = "3840x2160x32";
  };

  boot.plymouth.extraConfig = "DeviceScale=2";
}
