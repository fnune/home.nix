_: {
  system.stateVersion = "23.05";

  imports = [
    ../options.nix
    ./audio.nix
    ./authorization.nix
    ./browsers.nix
    ./cachix.nix
    ./containerization.nix
    ./fonts.nix
    ./networking.nix
    ./packaging.nix
    ./plasma.nix
    ./plymouth.nix
    ./region-language.nix
    ./utils.nix
    ./work.nix
  ];

  users.users.fausto = {
    isNormalUser = true;
    description = "Fausto Núñez Alberro";
  };

  services.earlyoom.enable = true;
}
