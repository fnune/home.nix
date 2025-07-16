{pkgs, ...}: {
  home.packages = with pkgs; [
    darktable
    exiftool
    inkscape
    krita
  ];
}
