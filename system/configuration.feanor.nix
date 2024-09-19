{pkgs, ...}: {
  imports = [./configuration.nix ./hardware-configuration.feanor.nix];

  networking.hostName = "feanor";

  # Dual boot
  environment.systemPackages = [pkgs.os-prober];
  boot.loader.timeout = null; # Infinite time to choose
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
  time.hardwareClockInLocalTime = true; # Windows gets confused otherwise

  swapDevices = [
    {
      device = "/swapfile";
      size = 8192;
    }
  ];
}
