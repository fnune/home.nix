{pkgs, ...}: {
  users.users.fausto.extraGroups = [
    "dialout"
    "networkmanager"
    "pcap"
    "wireshark"
  ];

  hardware.bluetooth.enable = true;
  networking.networkmanager.enable = true;

  programs = {
    wireshark = {
      enable = true;
      package = pkgs.wireshark;
    };
    tcpdump = {
      enable = true;
    };
  };

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
    traceroute
    wget
    whois
  ];
}
