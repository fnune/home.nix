{pkgs, ...}: {
  services.pacman.packages = ["tcpdump" "wireshark-qt"];

  home.packages = with pkgs; [
    dig
    inetutils
    nettools
    nmap
    sshfs
    traceroute
    whois
  ];
}
