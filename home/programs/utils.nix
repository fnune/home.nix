{pkgs, ...}: {
  home.packages = with pkgs; [
    ddcutil
    dmidecode
    du-dust
    exiftool
    fd
    ffmpeg
    file
    gcc
    gnumake
    gzip
    jq
    killall
    lm_sensors
    lshw
    lsof
    man-pages
    man-pages-posix
    moreutils
    pciutils
    tree
    unzip
    util-linux
    watchexec
    wl-clipboard
  ];
}
