{
  config,
  pkgs,
  ...
}:
let
  profileDir = ".config/obs-studio/basic/profiles/Untitled";
  configFile = "${config.home.homeDirectory}/${profileDir}/basic.ini";

  defaultConfig = pkgs.writeText "obs-basic.ini" (
    builtins.replaceStrings [ "@videosDir@" ] [ "${config.home.homeDirectory}/Videos" ] (
      builtins.readFile ./obs/basic.ini
    )
  );

  initScript = pkgs.writeShellScript "init-obs-config" ''
    if [ ! -f "${configFile}" ]; then
      mkdir -p "$(dirname "${configFile}")"
      cp ${defaultConfig} "${configFile}"
      echo "Created OBS config at ${configFile}"
    fi
  '';
in
{
  services.pacman.packages = [ "obs-studio" ];

  home.activation.initObsConfig = config.lib.dag.entryAfter [ "writeBoundary" ] ''
    ${initScript}
  '';
}
