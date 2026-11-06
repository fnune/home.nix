{ ... }: {
  imports = [
    ./headless.nix
    ./applications.nix
    ./audio.nix
    ./browsers.nix
    ./earendil-browser.nix
    ./games.nix
    ./kate.nix
    ./obs.nix
    ./obsbot-first.nix
  ];

  programs.webcam-bubble.enable = true;
}
