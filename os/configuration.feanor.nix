{pkgs, ...}: {
  imports = [./configuration.nix ./hardware-configuration.feanor.nix];

  networking.hostName = "feanor";

  # Dual boot
  environment.systemPackages = [pkgs.os-prober];
  boot = {
    plymouth.extraConfig = "DeviceScale=1";
    loader = {
      timeout = null; # Infinite time to choose
      grub = {
        enable = true;
        device = "nodev";
        efiInstallAsRemovable = true;
        efiSupport = true;
        useOSProber = true;
        gfxmodeEfi = "2560x1440";
        gfxpayloadEfi = "2560x1440x32";
      };
    };
  };
  time.hardwareClockInLocalTime = true; # Windows gets confused otherwise

  swapDevices = [
    {
      device = "/swapfile";
      size = 8192;
    }
  ];
}
