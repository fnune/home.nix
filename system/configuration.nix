{pkgs, ...}: {
  system.stateVersion = "23.05";

  imports = [./plasma.nix ./browsers.nix ./audio.nix ./plymouth.nix ./work.nix];

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
    extraLocaleSettings = import ../user/locales.nix;
  };
  services.automatic-timezoned.enable = true;

  # Pinentry integration
  services.pcscd.enable = true;
  programs.ssh.enableAskPassword = true;
  environment.sessionVariables.SSH_ASKPASS_REQUIRE = "prefer";
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  # Package management
  nix.settings.experimental-features = ["nix-command" "flakes"];
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.allowUnfreePredicate = _: true;
  services.flatpak.enable = true;

  # Steam, plus fixes for 32-bit apps
  programs.steam.enable = true;
  environment.sessionVariables.STEAM_FORCE_DESKTOPUI_SCALING = "1.3";

  # Connectivity
  networking.networkmanager.enable = true;
  hardware.bluetooth.enable = true;
  services.mullvad-vpn.enable = true;
  services.mullvad-vpn.package = pkgs.mullvad-vpn;
  services.tailscale.enable = false;

  # Enable CUPS to print documents
  services.printing.enable = true;

  # Docker setup
  virtualisation.docker.enable = true;

  # Enable additional man pages (see also pkgs.man-pages-posix)
  documentation.dev.enable = true;

  # Clean up old configurations regularly
  nix.gc = {
    automatic = true;
    randomizedDelaySec = "14m";
    options = "--delete-older-than 10d";
  };
  nix.optimise.automatic = true;

  # Help unpatched binaries find the libraries they need
  programs.nix-ld.enable = true;

  # Control external monitor brightness
  services.udev.packages = [pkgs.ddcutil];
  hardware.i2c.enable = true;

  # Eager OOM killer
  services.earlyoom.enable = true;

  # Allows e.g. using the right file picker
  xdg.portal.enable = true;

  # Show stars while entering sudo password
  security.sudo.extraConfig = "Defaults pwfeedback";

  # Packages I want always to be available
  environment.systemPackages = with pkgs; [
    btop
    ddcui
    ddcutil
    dig
    dmidecode
    docker-compose
    du-dust
    eza
    file
    gcc
    git
    gnumake
    gzip
    inter
    jq
    killall
    lazydocker
    lshw
    lsof
    man-pages
    man-pages-posix
    neovim
    nmap
    noto-fonts-cjk-sans
    tree
    unzip
    util-linux
    wget
    wl-clipboard
    zsh
  ];
}
