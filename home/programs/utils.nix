{pkgs, ...}: {
  services.pacman.packages = ["base-devel" "docker" "docker-buildx"];

  home.packages = with pkgs; [
    exiftool
    fd
    ffmpeg
    jq
    lm_sensors
    lshw
    lsof
    moreutils
    tree
    watchexec
    wl-clipboard
  ];
}
