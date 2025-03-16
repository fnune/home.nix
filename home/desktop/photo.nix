{pkgs, ...}: {
  home.packages = with pkgs.unstable; [
    czkawka-full
    darktable
    exiftool
    gimp-with-plugins
    inkscape
    krita
  ];
}
