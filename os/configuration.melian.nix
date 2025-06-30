{
  pkgs,
  config,
  ...
}: {
  system.stateVersion = "24.05";

  imports = [./configuration.nix ./hardware-configuration.melian.nix];

  networking.hostName = "melian";
  boot = {
    loader = {
      timeout = 0;
      systemd-boot.enable = true;
    };
    plymouth.extraConfig = "DeviceScale=1";
    extraModulePackages = with config.boot.kernelPackages; [yt6801];
    kernelParams = [
      # Recommended by Tuxedo support (personal email):
      "acpi.ec_no_wakeup=1" # Fixes ACPI wakeup issues
      "amdgpu.dcdebugmask=0x10" # Fixes Wayland slowdowns/freezes
    ];
  };

  hardware = {
    tuxedo-drivers.enable = true;
    tuxedo-control-center.enable = true;
  };

  systemd = {
    services.vanta = {
      # Remember to call sudo /var/vanta/vanta-cli register --secret=<secret> --email=<email>
      enable = true;
      inherit (import ../packages/vanta.nix {inherit pkgs;}) wantedBy description serviceConfig;
    };
  };
}
