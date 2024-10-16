{
  pkgs,
  config,
  ...
}: let
  colorschemeConf =
    if config.colorscheme == "vscode"
    then builtins.readFile ./tmux.vscode.conf
    else if config.colorscheme == "rose-pine"
    then builtins.readFile ./tmux.rose-pine.conf
    else "";
in {
  programs.tmux = {
    enable = true;
    package = pkgs.unstable.tmux;
    extraConfig = builtins.readFile ./tmux.conf + "\n" + colorschemeConf;
    terminal = "tmux-256color";
    plugins = with pkgs.unstable.tmuxPlugins; [
      yank
      vim-tmux-navigator
      extrakto
    ];
  };
}
