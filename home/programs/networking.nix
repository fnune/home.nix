{pkgs, ...}: {
  services.pacman.packages = ["wireshark-qt"];

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
