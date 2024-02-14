{pkgs, ...}: {
  programs.tmux = {
    enable = true;
    package = pkgs.unstable.tmux;
    extraConfig = builtins.readFile ./tmux.conf;
    terminal = "tmux-256color";
    plugins = with pkgs.tmuxPlugins; [
      yank
      vim-tmux-navigator
      extrakto
    ];
  };
}
