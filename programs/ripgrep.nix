{pkgs, ...}: let
  fzfRgCommand = ''
    rg --hidden --files --follow -g \"!{.git,node_modules}/*\" 2> /dev/null
  '';
in {
  home.packages = [pkgs.ripgrep];
  programs.fzf = {
    defaultCommand = fzfRgCommand;
    fileWidgetCommand = fzfRgCommand;
  };
}
