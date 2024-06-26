{pkgs, ...}: {
  imports = [
    ./configuration.nix
    ./work.nix
    ./hardware-configuration.feanor.nix
  ];

  networking.hostName = "feanor";

  # Dual boot
  environment.systemPackages = [pkgs.os-prober pkgs.ddcutil];
  boot.loader.grub = {
    enable = true;
    device = "nodev";
    efiInstallAsRemovable = true;
    efiSupport = true;
    useOSProber = true;
    gfxmodeEfi = "2560x1440";
    gfxpayloadEfi = "2560x1440x32";
  };
  boot.plymouth.extraConfig = "DeviceScale=1";

  swapDevices = [
    {
      device = "/swapfile";
      size = 8192;
    }
  ];

  services.udev.packages = [pkgs.ddcutil];
  services.ddccontrol.enable = true;
  hardware.i2c.enable = true;
}
