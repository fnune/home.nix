_: {
  imports = [
    ../options.nix
    ./audio.nix
    ./authorization.nix
    ./fonts.nix
    ./networking.nix
    ./packaging.nix
    ./plasma.nix
    ./plymouth.nix
    ./printing.nix
    ./region-language.nix
    ./utils.nix
    ./virtualization.nix
  ];

  users.users.fausto = {
    isNormalUser = true;
    description = "Fausto Núñez Alberro";
  };

  services.earlyoom.enable = true;
}
