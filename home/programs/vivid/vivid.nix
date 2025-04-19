{
  pkgs,
  config,
  ...
}: {
  home.packages = with pkgs; [vivid];
  home.sessionVariables.LS_COLORS =
    if config.colorscheme == "standard"
    then "$(vivid generate ${config.home.homeDirectory}/.local/share/nvim/lazy/standard/vivid/standard.yml)"
    else "";
}
