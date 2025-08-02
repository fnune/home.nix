{pkgs, ...}: {
  home.packages = with pkgs; [
    exiftool
    fd
    ffmpeg
    gcc
    gnumake
    jq
    lm_sensors
    lshw
    moreutils
    watchexec
    wl-clipboard
  ];
}
