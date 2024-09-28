{
  pkgs,
  config,
  lib,
  ...
}: {
  home.packages = [pkgs.noto-fonts-emoji pkgs.unstable.nerdfonts];

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
