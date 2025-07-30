{pkgs, ...}: {
  services.apt.packages = ["wireshark"];

  home.packages = with pkgs; [
    curl
    dig
    inetutils
    nettools
    nmap
    openssl
    sshfs
    traceroute
    wget
    whois
  ];
}
