# Taken from https://primamateria.github.io/blog/playwright-nixos-webdev
{
  pkgs,
  version,
  sha256,
}: let
  fontconfig = pkgs.makeFontsConf {fontDirectories = [];};
  playwright-browsers-json = pkgs.stdenv.mkDerivation rec {
    name = "playwright-${version}-browsers";
    src = pkgs.fetchFromGitHub {
      owner = "Microsoft";
      repo = "playwright";
      rev = "v${version}";
      sha256 = sha256;
    };
    installPhase = ''
      mkdir -p $out
      cp packages/playwright-core/browsers.json $out/browsers.json
    '';
  };
in
  pkgs.runCommand "playwright-browsers-chromium"
  {
    nativeBuildInputs = [
      pkgs.makeWrapper
      pkgs.jq
    ];
  }
  ''
    BROWSERS_JSON=${playwright-browsers-json}/browsers.json
    CHROMIUM_REVISION=$(jq -r '.browsers[] | select(.name == "chromium").revision' $BROWSERS_JSON)
    mkdir -p $out/chromium-$CHROMIUM_REVISION/chrome-linux

    # See here for the Chrome options:
    # https://github.com/NixOS/nixpkgs/issues/136207#issuecomment-908637738
    makeWrapper ${pkgs.chromium}/bin/chromium $out/chromium-$CHROMIUM_REVISION/chrome-linux/chrome \
      --set SSL_CERT_FILE /etc/ssl/certs/ca-bundle.crt \
      --set FONTCONFIG_FILE ${fontconfig}

    FFMPEG_REVISION=$(jq -r '.browsers[] | select(.name == "ffmpeg").revision' $BROWSERS_JSON)
    mkdir -p $out/ffmpeg-$FFMPEG_REVISION
    ln -s ${pkgs.ffmpeg}/bin/ffmpeg $out/ffmpeg-$FFMPEG_REVISION/ffmpeg-linux
  ''
