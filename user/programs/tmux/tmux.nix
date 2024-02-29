{
  pkgs,
  config,
  ...
}: let
  colorschemeConf =
    if config.colorscheme == "vscode"
    then ./tmux.vscode.conf
    else "";
in {
  programs.tmux = {
    enable = true;
    package = pkgs.unstable.tmux;
    extraConfig = builtins.readFile ./tmux.conf + "\n" + colorschemeConf;
    terminal = "tmux-256color";
    plugins = with pkgs.tmuxPlugins; [
      yank
      vim-tmux-navigator
      extrakto
    ];
  };
}
