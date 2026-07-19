{
  pkgs,
  lib,
  config,
  standard,
  ...
}: {
  home.packages = with pkgs; [vivid];
  home.sessionVariables.LS_COLORS =
    lib.optionalString (config.colorscheme == "standard")
    "$(vivid generate ${standard}/vivid/standard.yml)";
}
