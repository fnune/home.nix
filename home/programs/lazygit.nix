{config, ...}: let
  jetbrainsTool = config.jetbrains.tool;
in {
  programs = {
    lazygit = {
      enable = true;
      settings = {
        os = {
          edit = "${jetbrainsTool} {{filename}}";
          editAtLine = "${jetbrainsTool} --line {{line}} {{filename}}";
          editAtLineAndWait = "${jetbrainsTool} --line {{line}} {{filename}} --wait";
          open = "${jetbrainsTool} {{filename}}";
          openDirInEditor = "${jetbrainsTool} {{filename}}";
        };
      };
    };
  };
}
