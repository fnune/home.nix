{
  pkgs,
  config,
  ...
}: {
  home.packages = with pkgs; [vivid];
  home.sessionVariables.LS_COLORS =
    if config.colorscheme == "vscode"
    then "$(vivid generate " + ./vscode.yml + ")"
    else if config.colorscheme == "rose-pine"
    then "$(vivid generate rose-pine)"
    else "";
}
