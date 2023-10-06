{...}: {
  home.file.".config/kitty/kitty.conf".text = ''
    foreground              #D4D4D4
    background              #1E1E1E
    selection_foreground    #D4D4D4
    selection_background    #264F78

    cursor                  #AEAFAD
    cursor_text_color       #1E1E1E

    active_border_color     #898989
    inactive_border_color   #444444

    active_tab_foreground   #D4D4D4
    active_tab_background   #1E1E1E
    inactive_tab_foreground #BBBBBB
    inactive_tab_background #2D2D2D

    # black
    color0 #222222
    color8 #51504F

    # red
    color1 #F44747
    color9 #FB0101

    # green
    color2  #6A9955
    color10 #81b88b

    # yellow
    color3  #DCDCAA
    color11 #FFD602

    # blue
    color4  #569CD6
    color12 #4FC1FE

    # magenta
    color5  #C586C0
    color13 #646695

    # cyan
    color6  #4EC9B0
    color14 #18a2fe

    # white
    color7  #D4D4D4
    color15 #D4D4D4
  '';

  programs.fzf.colors = {
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
  };
}
