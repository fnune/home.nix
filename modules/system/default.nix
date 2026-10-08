{ ... }: {
  imports = [
    ./nix.nix
    ./pacman.nix
    ./ssh.nix
    ./storage.nix
    ./wireguard.nix
  ];
}
