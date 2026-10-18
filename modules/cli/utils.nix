{ pkgs, ... }: {
  home.packages = with pkgs; [
    age
    exiftool
    fd
    ffmpeg
    jq
    lm_sensors
    lshw
    lsof
    moreutils
    sops
    ssh-to-age
    strace
    tree
    watchexec
    wl-clipboard
  ];
}
