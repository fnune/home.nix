{
  lib,
  pkgs,
  standard,
  ...
}:
{
  home.packages = with pkgs; [ vivid ];
  home.sessionVariables.LS_COLORS = "$(${lib.getExe pkgs.vivid} generate ${standard}/vivid/standard.yml)";
}
