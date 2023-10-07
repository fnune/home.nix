{pkgs, ...}: {
  system.stateVersion = "23.05";

  boot = {
    # Set up plymouth
    initrd.systemd.enable = true;
    plymouth = {
      enable = true;
      theme = "spinner";
    };
    kernelParams = ["quiet" "loglevel=3" "systemd.show_status=auto" "rd.udev.log_level=3"];

    # Potential dual boot
    loader.grub = {
      enable = true;
      device = "nodev";
      efiInstallAsRemovable = true;
      efiSupport = true;
      gfxmodeEfi = "auto";
      useOSProber = true;
    };

    # I've got some modern hardware
    kernelPackages = pkgs.linuxPackages_latest;

    # Enable greedy file watchers
    kernel.sysctl = {
      "fs.inotify.max_user_instances" = "1048576";
      "fs.inotify.max_user_watches" = "1048576";
    };
  };

  # Region and language
  time.timeZone = "Europe/Berlin";
  services.xserver = {
    layout = "es";
    xkbVariant = "";
  };
  console.keyMap = "es";
  i18n = let
    en_default = "en_US.UTF-8";
    en_metric = "en_DK.UTF-8";
    en_yymmdd = "en_GB.UTF-8";
    euro = "de_DE.UTF-8";
  in {
    defaultLocale = en_default;
    extraLocaleSettings = {
      LC_CTYPE = en_default;
      LC_MESSAGES = en_default;
      LC_IDENTIFICATION = en_default;
      LC_COLLATE = en_default;

      LC_MEASUREMENT = en_metric;

      LC_TIME = en_yymmdd;

      LC_ADDRESS = euro;
      LC_MONETARY = euro;
      LC_NAME = euro;
      LC_NUMERIC = euro;
      LC_PAPER = euro;
      LC_TELEPHONE = euro;
    };
  };

  # Plasma
  services.xserver.enable = true;
  services.xserver.displayManager.sddm.enable = true;
  services.xserver.desktopManager.plasma5.enable = true;
  services.unclutter.enable = true;

  # Pinentry and Kwallet integration
  services.pcscd.enable = true;
  environment.sessionVariables.SSH_ASKPASS_REQUIRE = "prefer";
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
    pinentryFlavor = "gtk2";
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
  networking.hosts."127.0.0.1" = ["minio" "rabbitmq"];
  virtualisation.docker.enable = true;

  # Define a user account
  users.users.fausto = {
    isNormalUser = true;
    description = "Fausto Núñez Alberro";
    extraGroups = ["networkmanager" "wheel" "dialout" "docker"];
  };

  # Configure the Nix package manager
  nixpkgs.config.allowUnfree = true;
  nix.settings.experimental-features = ["nix-command" "flakes"];

  # Consider installing in home.nix instead
  environment.systemPackages = with pkgs; [
    # System and CLI
    gcc
    git
    gnumake
    neovim
    os-prober
    tree
    wget
    xclip
    zsh

    # Desktop-related
    inter
    noto-fonts-cjk-sans
    pkgs.libsForQt5.sddm-kcm
  ];

  # Internet!
  programs.firefox.enable = true;
  networking.networkmanager.enable = true;
}
