{config, ...}: {
  services.pacman.packages = [
    "inter-font"
    "noto-fonts-cjk"
    "noto-fonts-emoji"
    "ttf-jetbrains-mono"
    "ttf-sourcecodepro-nerd"
  ];

  fonts = {
    fontconfig = {
      enable = true;

      defaultFonts = {
        serif = [config.fontconfig.sans];
        sansSerif = [config.fontconfig.sans];
        monospace = [config.fontconfig.mono];
        emoji = [config.fontconfig.emoji];
      };
    };
  };

  xdg.configFile = {
    "fontconfig/conf.d/60-hm-aliases.conf".text = let
      sansAliases = [
        "-apple-system"
        "Helvetica"
        "Inter"
      ];
      monoAliases = [
        "DejaVu Sans Mono"
        "Liberation Mono"
        "SF Mono"
        "SFMono-Regular"
      ];
      makeAliases = aliases: targetFont:
        builtins.concatStringsSep "\n" (
          map (alias: ''
            <alias binding="strong">
              <family>${alias}</family>
              <prefer>
                <family>${targetFont}</family>
              </prefer>
            </alias>
          '')
          aliases
        );
    in ''
      <?xml version="1.0" encoding="UTF-8"?>
      <!DOCTYPE fontconfig SYSTEM "fonts.dtd">
      <fontconfig>
        ${makeAliases sansAliases config.fontconfig.sans}
        ${makeAliases monoAliases config.fontconfig.mono}
      </fontconfig>
    '';
  };
}
