{pkgs, ...}: {
  users.users.fausto.extraGroups = ["networkmanager" "dialout"];

  networking.networkmanager.enable = true;

  hardware.bluetooth.enable = true;
  programs.wireshark.enable = true;

  services = {
    mullvad-vpn = {
      enable = true;
      package = pkgs.mullvad-vpn;
    };
  };

  environment.systemPackages = with pkgs; [
    dig
    lsof
    nettools
    nmap
    tcpdump
    traceroute
    wget
    whois
  ];
}
