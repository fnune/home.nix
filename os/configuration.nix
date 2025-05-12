_: {
  imports = [
    ../options.nix
    ./audio.nix
    ./authorization.nix
    ./containerization.nix
    ./fonts.nix
    ./networking.nix
    ./packaging.nix
    ./plasma.nix
    ./plymouth.nix
    ./printing.nix
    ./region-language.nix
    ./utils.nix
  ];

  users.users.fausto = {
    isNormalUser = true;
    description = "Fausto Núñez Alberro";
  };

  services.earlyoom.enable = true;
}
