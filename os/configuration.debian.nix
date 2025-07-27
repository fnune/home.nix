{
  pkgs,
  config,
  ...
}: {
  config = {
    system-manager.allowAnyDistro = true;
    nixpkgs.hostPlatform = "x86_64-linux";

    nixpkgs = {
      config = {
        allowUnfree = true;
        allowUnfreePredicate = _: true;
      };
    };

    fonts = {
      packages = with pkgs; [
        adwaita-fonts
        nerd-fonts.sauce-code-pro
        noto-fonts-cjk-sans
        noto-fonts-cjk-serif
        noto-fonts-emoji
      ];
    };

    environment = {
      systemPackages = with pkgs; [
        curl
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
