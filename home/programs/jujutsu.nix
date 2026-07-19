{
  config,
  lib,
  pkgs,
  standard,
  ...
}: let
  repoUi = pkgs.writeShellScriptBin "repo-ui" ''
    set -euo pipefail

    jj root >/dev/null 2>&1 || jj git init --colocate

    exec jjui
  '';
in {
  home.packages = [pkgs.jjui repoUi];

  xdg.configFile = lib.mkIf (config.colorscheme == "standard") {
    "jj/conf.d/standard.toml".source = "${standard}/jj/standard.dark.toml";
    "jjui/themes/standard.dark.toml".source = "${standard}/jjui/standard.dark.toml";
    "jjui/config.toml".text = ''
      [ui]
      theme = "standard.dark"
    '';
  };

  programs.jujutsu = {
    enable = true;
    settings = {
      user = {
        name = config.profile.name;
        email = config.profile.email.personal;
      };
      signing = {
        behavior = "own";
        backend = "ssh";
        key = "${config.profile.sshKeyPath}.pub";
      };
      ui.default-command = "log";
    };
  };
}
