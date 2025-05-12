{pkgs, ...}: {
  system.stateVersion = "23.05";

  imports = [./configuration.nix ./hardware-configuration.feanor.nix];

  networking.hostName = "feanor";

  # Dual boot
  environment.systemPackages = [pkgs.os-prober];
  boot = {
    plymouth.extraConfig = "DeviceScale=2";
    loader = {
      timeout = null; # Infinite time to choose
      grub = {
        enable = true;
        device = "nodev";
        efiInstallAsRemovable = true;
        efiSupport = true;
        useOSProber = true;
        gfxmodeEfi = "3840x2160";
        gfxpayloadEfi = "3840x2160x32";
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

  hardware.logitech.wireless = {
    enable = true;
    enableGraphical = true;
  };
}
