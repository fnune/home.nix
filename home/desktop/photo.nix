{pkgs, ...}: {
  home.packages = with pkgs; [
    darktable
    exiftool
    ffmpeg
  ];
}
