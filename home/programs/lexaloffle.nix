{
  pkgs,
  config,
  ...
}: let
  projects.pico-8 = "${config.home.homeDirectory}/Development/pico-8/projects";
  lexaloffle.pico-8 = "${config.home.homeDirectory}/.lexaloffle/pico-8";
  bin.pico-8 = "${config.home.homeDirectory}/Development/pico-8/bin";
  pico8-ls-extension = pkgs.vscode-extensions.pollywoggames.pico8-ls;
  pico8-ls = pkgs.writeShellScriptBin "pico8-ls" ''
    exec ${pkgs.nodejs}/bin/node ${pico8-ls-extension}/share/vscode/extensions/PollywogGames.pico8-ls/server/out-min/main.js "$@"
  '';
in {
  home = {
    packages = [pico8-ls];
    file = {
      "${lexaloffle.pico-8}/config.txt".text = ''
        root_path ${projects.pico-8}
        windowed 1
        window_position -1 -1
        video_mode 1160 1080
      '';
    };
  };
  xdg.desktopEntries.pico-8 = {
    name = "PICO-8";
    genericName = "Fantasy Console";
    exec = "${bin.pico-8}/pico8";
    icon = "${bin.pico-8}/lexaloffle-pico8.png";
    terminal = false;
    categories = ["Game" "Development"];
  };
}
