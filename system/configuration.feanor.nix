{pkgs, ...}: {
  imports = [
    ./configuration.nix
    ./work.nix
    ./hardware-configuration.feanor.nix
  ];

  networking.hostName = "feanor";

  # Dual boot
  environment.systemPackages = [pkgs.os-prober];
  boot.loader.grub = {
    enable = true;
    device = "nodev";
    efiInstallAsRemovable = true;
    efiSupport = true;
    useOSProber = true;
    gfxmodeEfi = "1920x1080";
    gfxpayloadEfi = "1920x1080x32";
  };
}
