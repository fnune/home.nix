{pkgs, ...}: let
  port = 1716;
in {
  environment.systemPackages = with pkgs; [
    gnomeExtensions.gsconnect
  ];
  networking.firewall.allowedTCPPorts = [port];
  networking.firewall.allowedUDPPorts = [port];
}
