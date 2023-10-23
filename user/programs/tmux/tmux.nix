{pkgs, ...}: {
  programs.tmux = {
    enable = true;
    extraConfig = builtins.readFile ./tmux.conf;
    terminal = "tmux-256color";
    plugins = with pkgs.tmuxPlugins; [
      yank
      vim-tmux-navigator
      extrakto
    ];
  };
}
