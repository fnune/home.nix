{pkgs, ...}: let
  patcherBin = "${pkgs.unstable.nerd-font-patcher}/bin/nerd-font-patcher";
  name = "SFMono Nerd Font";
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

  dconf.settings = {
    "org/gnome/desktop/interface" = {
      "monospace-font-name" = "${name} 10";
    };
  };

  xdg.configFile = {
    "fontconfig/conf.d/99-mono.conf".text = ''
      <?xml version="1.0" encoding="UTF-8"?>
      <fontconfig>
        <alias binding="strong">
          <family>monospace</family>
          <prefer>
            <family>${name}</family>
          </prefer>
        </alias>
        <alias binding="strong">
          <family>Liberation Mono</family>
          <prefer>
            <family>${name}</family>
          </prefer>
        </alias>
        <alias binding="strong">
          <family>SFMono-Regular</family>
          <prefer>
            <family>${name}</family>
          </prefer>
        </alias>
        <alias binding="strong">
          <family>SF Mono</family>
          <prefer>
            <family>${name}</family>
          </prefer>
        </alias>
      </fontconfig>
    '';
  };
}
