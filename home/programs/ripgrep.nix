{pkgs, ...}: let
  fzfRgCommand = ''
    ${pkgs.ripgrep}/bin/rg --hidden --files --follow -g \"!{.git}/*\" 2> /dev/null
  '';
in {
  home.packages = [pkgs.ripgrep];
  programs.fzf = {
    defaultCommand = fzfRgCommand;
    fileWidgetCommand = fzfRgCommand;
  };
}
