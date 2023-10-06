{pkgs, ...}: {
  home.packages = [pkgs.bfs];
  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
    changeDirWidgetCommand = "bfs -type d -nohidden 2> /dev/null";
  };

  programs.zsh.initExtra = ''
    # https://github.com/jeffreytse/zsh-vi-mode/issues/187
    function zvm_after_init() {
      zvm_bindkey viins '^R' fzf-history-widget
    }
  '';
}
