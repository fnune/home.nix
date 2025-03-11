{pkgs, ...}: {
  # Enable additional man pages (see also pkgs.man-pages-posix)
  documentation.dev.enable = true;

  # Control external monitor brightness
  services.udev.packages = [pkgs.ddcutil];
  hardware.i2c.enable = true;

  # Show stars while entering sudo password
  security.sudo.extraConfig = "Defaults pwfeedback";

  # Allow mounting with e.g. `sshfs` with `-o allow_other`
  programs.fuse.userAllowOther = true;

  environment.systemPackages = with pkgs; [
    ddcui
    ddcutil
    dmidecode
    du-dust
    file
    gcc
    git
    gnumake
    gzip
    jq
    killall
    lshw
    man-pages
    man-pages-posix
    neovim
    pciutils
    sshfs
    tree
    unzip
    util-linux
    wl-clipboard
    zsh
  ];
}
