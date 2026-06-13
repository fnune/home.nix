{
  pkgs,
  lib,
  config,
  ...
}: let
  colorschemeConf =
    lib.optionalString (config.colorscheme == "standard")
    (builtins.readFile ./tmux.standard.conf);
in {
  programs.tmux = {
    enable = true;
    extraConfig = builtins.readFile ./tmux.conf + "\n" + colorschemeConf;
    terminal = "tmux-256color";
    plugins = with pkgs.tmuxPlugins; [
      extrakto
      vim-tmux-navigator
      yank
    ];
  };
}
