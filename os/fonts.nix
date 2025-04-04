{
  pkgs,
  config,
  ...
}: {
  # https://blog.aktsbot.in/no-more-blurry-fonts.html
  environment.sessionVariables = {
    FREETYPE_PROPERTIES = "cff:no-stem-darkening=0 autofitter:no-stem-darkening=0";
  };
  fonts = {
    fontconfig = {
      enable = true;
      inherit (config.fontconfig) antialias;

      subpixel = {
        rgba = config.fontconfig.subpixel;
      };

      hinting = {
        enable = true;
        style = builtins.replaceStrings ["hint"] [""] config.fontconfig.hinting;
      };

      defaultFonts = {
        serif = [config.fontconfig.sans];
        sansSerif = [config.fontconfig.sans];
        monospace = [config.fontconfig.mono];
        emoji = [config.fontconfig.emoji];
      };

      includeUserConf = true;
      allowBitmaps = true;
      useEmbeddedBitmaps = true;

      localConf = let
        sansAliases = [
          "Helvetica"
          "-apple-system"
        ];

        monoAliases = [
          "Liberation Mono"
          "SFMono-Regular"
          "SF Mono"
          "DejaVu Sans Mono"
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
        <fontconfig>
          ${makeAliases sansAliases config.fontconfig.sans}
          ${makeAliases monoAliases config.fontconfig.mono}
        </fontconfig>
      '';
    };

    packages = with pkgs; [
      inter
      nerd-fonts.sauce-code-pro
      noto-fonts-cjk-sans
      noto-fonts-cjk-serif
      noto-fonts-emoji
    ];
  };
}
