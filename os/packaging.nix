_: {
  nix = {
    settings.experimental-features = ["nix-command" "flakes"];
    optimise.automatic = true;
  };

  nixpkgs = {
    config = {
      allowUnfree = true;
      allowUnfreePredicate = _: true;
    };
  };

  services = {
    flatpak.enable = true;
  };

  programs = {
    # Enable things like Volta for projects that need it
    nix-ld.enable = true;

    # Steam, plus fixes for 32-bit apps
    steam.enable = true;

    # Update utility & cleaning up of old configurations
    nh = {
      enable = true;
      clean.enable = true;
      clean.extraArgs = "--keep-since 10d --keep 10";
      flake = "/home/fausto/.home.nix/";
    };
  };

  environment.sessionVariables.STEAM_FORCE_DESKTOPUI_SCALING = "1.3";
}
