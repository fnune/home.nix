{
  pkgs,
  config,
  lib,
  ...
}: let
  patcherBin = "${pkgs.unstable.nerd-font-patcher}/bin/nerd-font-patcher";
  src = pkgs.fetchgit {
    url = "https://github.com/bahmanworld/San-Francisco-Mono.git";
    rev = "refs/tags/2022";
    sha256 = "sha256-Qn4v3Snci+gPMbz1n0s+l5YvRCNW3rFV8ajCWsz+4Ig";
  };
  sf-mono-font = pkgs.stdenv.mkDerivation {
    inherit src;
    name = "sf-mono-nerdfont";
    buildInputs = [pkgs.nerd-font-patcher];
    installPhase = let
      faces = [
        "SFMono-Bold.otf"
        "SFMono-BoldItalic.otf"
        "SFMono-Regular.otf"
        "SFMono-RegularItalic.otf"
      ];
    in ''
      mkdir -p $out/share/fonts/sf-mono-nerdfont
      for font in ${toString faces}; do
        echo "Patching $font..."
        ${patcherBin} "$src/$font" --complete -out $out/share/fonts/sf-mono-nerdfont > /dev/null 2>&1
      done
    '';
    postInstall = "fc-cache -fv";
  };
in {
  home.packages = [sf-mono-font pkgs.noto-fonts-emoji];

  # When changing font configuration using the UI, Plasma will use the first
  # file it finds in 'conf.d' as its target. Give it an empty file so that it
  # does not unlink other configuration files in this module:
  home.activation.writeDesktopFontconfig = lib.hm.dag.entryAfter ["writeBoundary"] ''
    touch ${config.home.homeDirectory}/.config/fontconfig/conf.d/00-desktop.conf
  '';

  # https://blog.aktsbot.in/no-more-blurry-fonts.html
  home.sessionVariables.FREETYPE_PROPERTIES = "cff:no-stem-darkening=0 autofitter:no-stem-darkening=0";

  xdg.configFile = {
    "fontconfig/conf.d/99-rendering.conf".text = ''
      <?xml version="1.0" encoding="UTF-8"?>
      <fontconfig>
        <match target="font">
          <edit mode="assign" name="rgba">
            <const>${config.fontconfig.subpixel}</const>
          </edit>
        </match>
        <match target="font">
          <edit mode="assign" name="hinting">
            <bool>true</bool>
          </edit>
        </match>
        <match target="font">
          <edit mode="assign" name="hintstyle">
            <const>${config.fontconfig.hinting}</const>
          </edit>
        </match>
        <match target="font">
          <edit mode="assign" name="antialias">
            <bool>${builtins.toString config.fontconfig.antialias}</bool>
          </edit>
        </match>
      </fontconfig>
    '';

    "fontconfig/conf.d/99-sans.conf".text = ''
      <?xml version="1.0" encoding="UTF-8"?>
      <fontconfig>
        <alias binding="strong">
          <family>sans-serif</family>
          <prefer>
            <family>${config.fontconfig.sans}</family>
          </prefer>
        </alias>
        <alias binding="strong">
          <family>Helvetica</family>
          <prefer>
            <family>${config.fontconfig.sans}</family>
          </prefer>
        </alias>
        <alias binding="strong">
          <family>-apple-system</family>
          <prefer>
            <family>${config.fontconfig.sans}</family>
          </prefer>
         </alias>
      </fontconfig>
    '';

    "fontconfig/conf.d/99-mono.conf".text = ''
      <?xml version="1.0" encoding="UTF-8"?>
      <fontconfig>
        <alias binding="strong">
          <family>monospace</family>
          <prefer>
            <family>${config.fontconfig.mono}</family>
          </prefer>
        </alias>
        <alias binding="strong">
          <family>Liberation Mono</family>
          <prefer>
            <family>${config.fontconfig.mono}</family>
          </prefer>
        </alias>
        <alias binding="strong">
          <family>SFMono-Regular</family>
          <prefer>
            <family>${config.fontconfig.mono}</family>
          </prefer>
        </alias>
        <alias binding="strong">
          <family>SF Mono</family>
          <prefer>
            <family>${config.fontconfig.mono}</family>
          </prefer>
        </alias>
      </fontconfig>
    '';
  };
}
