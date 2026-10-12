_:
let
  chromiumLibraries = [
    "alsa-lib"
    "at-spi2-core"
    "libx11"
    "libxcb"
    "libxcomposite"
    "libxdamage"
    "libxext"
    "libxfixes"
    "libxkbcommon"
    "libxrandr"
    "mesa"
    "nspr"
    "nss"
  ];

  commonDesktopFonts = [
    "noto-fonts"
    "noto-fonts-cjk"
    "noto-fonts-emoji"
    "ttf-dejavu"
    "ttf-liberation"
  ];
in
{
  services.pacman.packages = chromiumLibraries ++ commonDesktopFonts;
}
