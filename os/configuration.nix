{
  pkgs,
  config,
  ...
}: {
  system.stateVersion = "23.05";

  imports = [
    ../options.nix
    ./audio.nix
    ./browsers.nix
    ./cachix.nix
    ./fonts.nix
    ./plasma.nix
    ./plymouth.nix
    ./work.nix
  ];

  # Define a user account
  users.users.fausto = {
    isNormalUser = true;
    description = "Fausto Núñez Alberro";
    extraGroups = ["networkmanager" "wheel" "dialout" "docker"];
  };

  # Region and language
  services.xserver.xkb = {
    layout = "es";
    variant = "";
  };
  console.keyMap = "es";
  i18n = {
    defaultLocale = "en_US.UTF-8";
    extraLocaleSettings = import ../home/locales.nix;
  };
  services.automatic-timezoned.enable = true;

  # Enable full YubiKey functionality
  services.pcscd.enable = true;

  # Prefer GUI program for SSH unlocks even if requested from a terminal
  environment.sessionVariables.SSH_ASKPASS_REQUIRE = "prefer";
  programs.ssh.enableAskPassword = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  # Package management
  nix.settings.experimental-features = ["nix-command" "flakes"];
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.allowUnfreePredicate = _: true;

  # Steam, plus fixes for 32-bit apps
  programs.steam.enable = true;
  environment.sessionVariables.STEAM_FORCE_DESKTOPUI_SCALING = "1.3";

  # Connectivity
  networking.networkmanager.enable = true;
  hardware.bluetooth.enable = true;
  services.mullvad-vpn.enable = true;
  services.mullvad-vpn.package = pkgs.mullvad-vpn;
  services.tailscale.enable = false;

  # Docker setup
  virtualisation.docker.enable = true;

  # Enable additional man pages (see also pkgs.man-pages-posix)
  documentation.dev.enable = true;

  # Update utility & cleaning up of old configurations
  programs.nh = {
    enable = true;
    clean.enable = true;
    clean.extraArgs = "--keep-since 10d --keep 10";
    flake = "/home/fausto/.home.nix/";
  };
  nix.optimise.automatic = true;

  # Control external monitor brightness
  services.udev.packages = [pkgs.ddcutil];
  hardware.i2c.enable = true;

  # Eager OOM killer
  services.earlyoom.enable = true;

  # Allows e.g. using the right file picker
  xdg.portal.enable = true;

  # Show stars while entering sudo password
  security.sudo.extraConfig = "Defaults pwfeedback";

  # Enable things like Volta for projects that need it
  programs.nix-ld.enable = true;

  # Packages I want always to be available
  environment.systemPackages = with pkgs; [
    config.cursors.package
    ddcui
    ddcutil
    dig
    dmidecode
    docker-compose
    du-dust
    file
    gcc
    git
    gnumake
    gzip
    jq
    killall
    lazydocker
    lshw
    lsof
    man-pages
    man-pages-posix
    neovim
    nmap
    pciutils
    tree
    unzip
    util-linux
    volta
    wget
    wl-clipboard
    zsh
  ];
}
