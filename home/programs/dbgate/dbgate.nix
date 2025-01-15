{pkgs, ...}: let
  inherit (pkgs.unstable) dbgate;
  dbgate-icon = pkgs.fetchurl {
    url = "https://github.com/dbgate/dbgate/raw/35e9ff607d3014e0cb55f07d2705663581c03db2/app/icon.png";
    sha256 = "0ii15gj2rnf9nyw20b11s5nlwzv4qnpb1dllig186zc27kv0l1nn";
  };
in {
  home = {
    packages = [dbgate];
    file = {
      ".local/share/applications/dbgate.desktop".text = ''
        [Desktop Entry]
        Version=${pkgs.lib.getVersion dbgate}
        Name=DbGate
        Comment=Database Manager
        Exec=${dbgate}/bin/dbgate
        Icon=${dbgate-icon}
        Terminal=false
        Type=Application
        Categories=Development;Database;
      '';
    };
  };
}
