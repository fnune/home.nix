{
  pkgs,
  config,
  ...
}: let
  colorschemeConf =
    if config.colorscheme == "standard"
    then builtins.readFile ./tmux.standard.conf
    else "";
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

  programs.zsh.initExtra = builtins.readFile ./tmux-utils.sh;
}
