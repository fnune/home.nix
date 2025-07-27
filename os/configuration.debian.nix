{pkgs, ...}: {
  config = {
    system-manager.allowAnyDistro = true;
    nixpkgs.hostPlatform = "x86_64-linux";
    networking.hostName = "debian";

    boot = {
      plymouth = {
        enable = true;
        theme = "spinner";
        font = "${pkgs.adwaita-fonts}/share/fonts/Adwaita/AdwaitaSans-Regular.ttf";
      };
      kernelParams = ["quiet" "loglevel=3" "systemd.show_status=auto" "rd.udev.log_level=3"];
    };

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

    i18n = {
      defaultLocale = "en_US.UTF-8";
      extraLocaleSettings = import ../home/locales.nix;
    };

    environment = {
      systemPackages = with pkgs; [
        dig
        du-dust
        fd
        file
        gcc
        git
        gnumake
        gzip
        inetutils
        jq
        killall
        lm_sensors
        lshw
        lsof
        man-pages
        man-pages-posix
        moreutils
        nettools
        nmap
        openssl
        pciutils
        ripgrep
        sshfs
        traceroute
        tree
        unzip
        util-linux
        watchexec
        wget
        whois
        wl-clipboard
      ];
    };
  };
}
