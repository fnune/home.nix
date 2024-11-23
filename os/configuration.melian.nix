{...}: {
  imports = [./configuration.nix ./hardware-configuration.melian.nix];

  networking.hostName = "melian";
  boot = {
    loader = {
      timeout = 0;
      systemd-boot.enable = true;
    };
    plymouth.extraConfig = "DeviceScale=1";
  };
}
