{
  pkgs,
  standard,
  ...
}: {
  home.packages = with pkgs; [vivid];
  home.sessionVariables.LS_COLORS = "$(vivid generate ${standard}/vivid/standard.yml)";
}
