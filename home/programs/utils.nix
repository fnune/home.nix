{pkgs, ...}: {
  services.pacman.packages = ["base-devel" "docker" "docker-buildx"];

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
