{pkgs, ...}: {
  services.pacman.packages = ["base-devel"];

  home.packages = with pkgs; [
    exiftool
    fd
    ffmpeg
    jq
    lm_sensors
    lshw
    lsof
    moreutils
    strace
    tree
    watchexec
    wl-clipboard
  ];
}
