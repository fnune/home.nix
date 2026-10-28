{ ... }: {
  imports = [
    ./headless.nix
    ./kitty/kitty.nix
    ./networking.nix
    ./secret-scan
  ];
}
