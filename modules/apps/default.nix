{ ... }: {
  imports = [
    ./headless.nix
    ./applications.nix
    ./audio.nix
    ./browsers.nix
    ./kate.nix
    ./obs.nix
  ];
}
