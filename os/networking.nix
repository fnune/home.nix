{pkgs, ...}: {
  users.users.fausto.extraGroups = ["networkmanager" "dialout" "wireshark"];

  hardware.bluetooth.enable = true;
  networking.networkmanager.enable = true;

  programs.wireshark = {
    enable = true;
    package = pkgs.wireshark;
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
    tcpdump
    traceroute
    wget
    whois
  ];
}
