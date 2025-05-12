{...}: {
  system.stateVersion = "24.05";

  imports = [./configuration.nix ./hardware-configuration.melian.nix];

  networking.hostName = "melian";
  boot = {
    loader = {
      timeout = 0;
      systemd-boot.enable = true;
    };
    plymouth.extraConfig = "DeviceScale=1";
  };

  hardware = {
    tuxedo-drivers.enable = true;
    tuxedo-rs = {
      enable = true;
      tailor-gui.enable = true;
    };
  };
}
