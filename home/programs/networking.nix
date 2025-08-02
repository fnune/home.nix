{pkgs, ...}: {
  services.apt.packages = ["wireshark"];

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
