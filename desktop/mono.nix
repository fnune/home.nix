{pkgs, ...}: let
  patcher = "${pkgs.nerd-font-patcher}/bin/nerd-font-patcher";
  sfMono = pkgs.fetchgit {
    url = "https://github.com/bahmanworld/San-Francisco-Mono.git";
    rev = "refs/tags/2022";
    sha256 = "sha256-Qn4v3Snci+gPMbz1n0s+l5YvRCNW3rFV8ajCWsz+4Ig";
  };
  sfMonoNerdfontName = "SF Mono Nerd Font";
  sfMonoNerdfont = pkgs.stdenv.mkDerivation {
    name = "sf-mono-nerdfont";
    src = sfMono;
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
        ${patcher} "$src/$font" --complete -out $out/share/fonts/sf-mono-nerdfont > /dev/null 2>&1
      done
    '';
  };
in {
  home.packages = [sfMonoNerdfont pkgs.noto-fonts-emoji];

  xdg.configFile = {
    "fontconfig/conf.d/99-mono.conf".text = ''
      <?xml version="1.0" encoding="UTF-8"?>
      <fontconfig>
        <alias binding="strong">
          <family>monospace</family>
          <prefer>
            <family>${sfMonoNerdfontName}</family>
            <family>Noto Color Emoji</family>
          </prefer>
        </alias>
      </fontconfig>
    '';
  };
}
