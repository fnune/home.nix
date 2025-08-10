{pkgs, ...}: {
  services.apt.packages = ["build-essential"];

  home.packages = with pkgs; [
    exiftool
    fd
    ffmpeg
    jq
    lm_sensors
    lshw
    moreutils
    tree
    watchexec
    wl-clipboard
  ];
}
