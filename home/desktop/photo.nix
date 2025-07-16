{pkgs, ...}: {
  home.packages = with pkgs.unstable; [
    darktable
    exiftool
    inkscape
    krita
  ];
}
