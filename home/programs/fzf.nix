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
      if config.colorscheme == "standard"
      then {
        "bg+" = "-1";
        "fg+" = "#f3f2f1";
        "hl+" = "#d53880";
        bg = "#0b0c0c";
        border = "#2a2c2e";
        fg = "#505a5f";
        gutter = "#0b0c0c";
        header = "#5694ca";
        hl = "#d53880";
        info = "#5694ca";
        marker = "#d4351c";
        pointer = "#6f72af";
        prompt = "#505a5f";
        separator = "#2a2c2e";
        spinner = "#b58840";
      }
      else {};
  };
}
