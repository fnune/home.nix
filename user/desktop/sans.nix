{pkgs, ...}: let
  font = "Inter";
  fontSize = 11;
in {
  home.packages = [pkgs.inter];

  dconf.settings = {
    "org/gnome/desktop/interface" = {
      "font-name" = "${font} ${builtins.toString fontSize}";
      "document-font-name" = "${font} ${builtins.toString fontSize}";
    };

    "org/gnome/desktop/wm/preferences" = {
      "titlebar-font" = "${font} Bold ${builtins.toString fontSize}";
    };
  };

  xdg.configFile = {
    "fontconfig/conf.d/99-sans.conf".text = ''
      <?xml version="1.0" encoding="UTF-8"?>
      <fontconfig>
        <alias binding="strong">
          <family>sans-serif</family>
          <prefer>
            <family>${font}</family>
          </prefer>
        </alias>
        <alias binding="strong">
          <family>Helvetica</family>
          <prefer>
            <family>${font}</family>
          </prefer>
        </alias>
        <alias binding="strong">
          <family>-apple-system</family>
          <prefer>
            <family>${font}</family>
          </prefer>
         </alias>
      </fontconfig>
    '';
  };
}
