{
  pkgs,
  config,
  ...
}: {
  home.packages = [pkgs.bfs];
  programs = {
    fzf = {
      enable = true;
      enableZshIntegration = true;
      changeDirWidgetCommand = "bfs -type d -nohidden 2> /dev/null";
    };
    zsh.initExtra = ''
      # https://github.com/jeffreytse/zsh-vi-mode/issues/187
      function zvm_after_init() {
        zvm_bindkey viins '^R' fzf-history-widget
      }
    '';
    fzf.colors =
      if config.colorscheme == "vscode"
      then {
        "bg+" = "-1";
        "fg+" = "#D4D4D4";
        "hl+" = "#C586C0";
        bg = "#1E1E1E";
        border = "#444444";
        fg = "#808080";
        gutter = "#1E1E1E";
        header = "#569CD6";
        hl = "#C586C0";
        info = "#9CDCFE";
        marker = "#F44747";
        pointer = "#646695";
        prompt = "#808080";
        separator = "#444444";
        spinner = "#D7BA7D";
      }
      else if config.colorscheme == "rose-pine"
      then {
        bg = "#191724";
        "bg+" = "-1";
        fg = "#908caa";
        "fg+" = "#e0def4";
        hl = "#ebbcba";
        "hl+" = "#ebbcba";
        border = "#403d52";
        header = "#31748f";
        gutter = "#191724";
        spinner = "#f6c177";
        info = "#9ccfd8";
        separator = "#403d52";
        pointer = "#c4a7e7";
        marker = "#eb6f92";
        prompt = "#908caa";
      }
      else {};
  };
}
