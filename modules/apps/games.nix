{ config, pkgs, ... }:
let
  flatpakExports = "${config.xdg.dataHome}/flatpak/exports/share";
  fightcade = "com.fightcade.Fightcade";
  nativeShaderCompilerVerbs = [
    "d3dx9_43"
    "d3dcompiler_43"
  ];

  installedCrtCgaShader = "${config.xdg.dataHome}/flatpak/app/${fightcade}/current/active/files/fightcade/Fightcade/emulator/fbneo/ui/shaders/crt_cga.fx";

  launchFightcade = pkgs.writeShellScript "fightcade" ''
    if ! ${pkgs.diffutils}/bin/cmp -s ${./fightcade/crt_cga.fx} "${installedCrtCgaShader}"; then
      ${pkgs.coreutils}/bin/rm -f "${installedCrtCgaShader}"
      ${pkgs.coreutils}/bin/install -m 644 ${./fightcade/crt_cga.fx} "${installedCrtCgaShader}"
    fi

    exec ${pkgs.flatpak}/bin/flatpak run --command=sh ${fightcade} -c '
      . /app/bin/get-wine-prefix
      for verb in ${toString nativeShaderCompilerVerbs}; do
        grep -qx "$verb" "$WINEPREFIX/winetricks.log" 2>/dev/null || winetricks --unattended "$verb"
      done
      exec /app/bin/fightcade
    '
  '';
in
{
  services.flatpak = {
    enable = true;
    packages = [ fightcade ];
  };

  home.packages = [ pkgs.flatpak ];
  xdg.systemDirs.data = [ flatpakExports ];

  home.file.".config/plasma-workspace/env/flatpak.sh" = {
    executable = true;
    text = ''
      export XDG_DATA_DIRS="${flatpakExports}''${XDG_DATA_DIRS:+:$XDG_DATA_DIRS}"
    '';
  };

  xdg.dataFile."applications/${fightcade}.desktop".text = ''
    [Desktop Entry]
    Type=Application
    Name=Fightcade
    Comment=Play arcade games online
    Exec=${launchFightcade}
    Icon=${fightcade}
    Categories=Game;Emulator;ArcadeGame;
    Keywords=retrogaming;arcade games;online gaming;
  '';
}
