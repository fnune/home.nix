{
  pkgs,
  lib,
  config,
  ...
}: {
  home.packages = with pkgs; [vivid];
  home.sessionVariables.LS_COLORS =
    lib.optionalString (config.colorscheme == "standard")
    "$(vivid generate ${config.home.homeDirectory}/.local/share/nvim/lazy/standard/vivid/standard.yml)";
}
