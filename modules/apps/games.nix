{ config, pkgs, ... }:
let
  flatpakExports = "${config.xdg.dataHome}/flatpak/exports/share";
in
{
  services.flatpak = {
    enable = true;
    packages = [ "com.fightcade.Fightcade" ];
  };

  home.packages = [ pkgs.flatpak ];
  xdg.systemDirs.data = [ flatpakExports ];

  home.file.".config/plasma-workspace/env/flatpak.sh" = {
    executable = true;
    text = ''
      export XDG_DATA_DIRS="${flatpakExports}''${XDG_DATA_DIRS:+:$XDG_DATA_DIRS}"
    '';
  };
}
