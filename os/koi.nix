{
  lib,
  stdenv,
  pkgs,
}:
stdenv.mkDerivation rec {
  pname = "koi";
  version = "0.3.1";

  src = pkgs.fetchFromGitHub {
    owner = "baduhai";
    repo = "Koi";
    rev = version;
    sha256 = "sha256-dhpuKIY/Xi62hzJlnVCIOF0k6uoQ3zH129fLq/r+Kmg";
  };

  # See https://github.com/baduhai/Koi/blob/master/development/Nix%20OS/dev.nix
  sourceRoot = "source/src";
  nativeBuildInputs = with pkgs; [cmake];
  buildInputs = with pkgs.kdePackages; [
    kconfig
    kcoreaddons
    kwidgetsaddons
    wrapQtAppsHook
  ];

  meta = with lib; {
    description = "Scheduled LIGHT/DARK Theme Switching for the KDE Plasma Desktop";
    license = licenses.lgpl3;
    platforms = platforms.linux;
    homepage = "https://github.com/baduhai/Koi";
  };
}
