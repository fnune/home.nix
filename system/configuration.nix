{pkgs, ...}: {
  system.stateVersion = "23.05";

  boot = {
    # Set up plymouth
    initrd.systemd.enable = true;
    plymouth = {
      enable = true;
      theme = "spinner";
      font = "${pkgs.inter}/share/fonts/truetype/Inter.ttc";
    };
    kernelParams = ["quiet" "loglevel=3" "systemd.show_status=auto" "rd.udev.log_level=3"];
    kernelPackages = pkgs.linuxPackages_6_8;
  };

  # Region and language
  services.xserver = {
    layout = "es";
    xkbVariant = "";
  };
  console.keyMap = "es";
  i18n = {
    defaultLocale = "en_US.UTF-8";
    extraLocaleSettings = import ../user/locales.nix;
  };
  services.automatic-timezoned.enable = true;

  # GNOME
  services.xserver.enable = true;
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;
  services.unclutter.enable = true;
  services.geoclue2.enable = true;
  imports = [./gsconnect.nix];

  # Pinentry and Kwallet integration
  services.pcscd.enable = true;
  environment.sessionVariables.SSH_ASKPASS_REQUIRE = "prefer";
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  # Enable CUPS to print documents
  services.printing.enable = true;
  security.sudo.extraConfig = "Defaults pwfeedback";

  # Enable sound with pipewire
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Docker setup
  virtualisation.docker.enable = true;

  # Define a user account
  users.users.fausto = {
    isNormalUser = true;
    description = "Fausto Núñez Alberro";
    extraGroups = ["networkmanager" "wheel" "dialout" "docker"];
  };

  # Configure the Nix package manager
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.allowUnfreePredicate = _: true;
  nix.settings.experimental-features = ["nix-command" "flakes"];

  # Consider installing in home.nix instead
  environment.systemPackages = with pkgs; [
    # System and CLI
    btop
    dig
    dmidecode
    docker-compose
    du-dust
    eza
    file
    gcc
    git
    gnumake
    jq
    killall
    lazydocker
    lshw
    lsof
    man-pages
    man-pages-posix
    neovim
    nmap
    tree
    util-linux
    wget
    wl-clipboard
    xclip
    zsh

    # Desktop-related
    inter
    noto-fonts-cjk-sans

    # Browsers
    firefox-devedition-bin
    google-chrome
  ];
  programs.firefox = {
    # Browser configuration
    enable = true;
    package = pkgs.firefox-bin;
    policies = {
      DisableAppUpdate = true;
      DisablePocket = true;
      DisplayBookmarksToolbar = "never";
      Homepage.StartPage = "none";
      PasswordManagerEnabled = false;
      SearchEngines.Default = "DuckDuckGo";
      Preferences = {
        "browser.aboutConfig.showWarning" = false;
        "browser.search.suggest.enabled" = false;
        "browser.sessionstore.max_resumed_crashes" = -1;
        "browser.translations.automaticallyPopup" = false;
        "browser.urlbar.resultMenu.keyboardAccessible" = false;
        "services.sync.username" = "fausto.nunez@mailbox.org";
        "widget.use-xdg-desktop-portal" = true;
        "widget.use-xdg-desktop-portal.file-picker" = 1;
      };
    };
  };
  environment.sessionVariables.MOZ_USE_XINPUT2 = "1"; # Improves trackpad scrolling in FF

  # Steam, plus fixes for 32-bit apps
  programs.steam.enable = true;

  # Connectivity
  networking.networkmanager.enable = true;
  hardware.bluetooth.enable = true;
  services.mullvad-vpn.enable = true;
  services.mullvad-vpn.package = pkgs.mullvad-vpn;
  services.tailscale.enable = true;

  # Enable additional man pages (see also pkgs.man-pages-posix)
  documentation.dev.enable = true;

  # Clean up old configurations regularly
  nix.gc = {
    automatic = true;
    randomizedDelaySec = "14m";
    options = "--delete-older-than 10d";
  };

  # Help unpatched binaries find the libraries they need
  programs.nix-ld.enable = true;
}
