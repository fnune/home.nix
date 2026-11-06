{ config, pkgs, ... }:
{
  services.flatpak = {
    enable = true;
    packages = [ "com.fightcade.Fightcade" ];
  };

  home.packages = [ pkgs.flatpak ];
  xdg.systemDirs.data = [ "${config.xdg.dataHome}/flatpak/exports/share" ];
}
