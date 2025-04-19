{
  config,
  pkgs,
  ...
}: let
  colorschemeConf =
    if config.colorscheme == "standard"
    then "include ${config.home.homeDirectory}/.local/share/nvim/lazy/standard/kitty/standard.dark.conf"
    else "";
in {
  home.packages = with pkgs; [unstable.kitty];

  home.file = {
    ".local/share/icons/hicolor/256x256/apps/kitty.png".source = ./whiskers.png;
    ".local/share/icons/hicolor/scalable/apps/kitty.svg".source = ./whiskers.svg;
    ".config/kitty/kitty.conf".text = ''
      shell ${config.shell.bin} ${pkgs.lib.concatStringsSep " " config.shell.args}

      map ctrl+PLUS change_font_size all +1
      map ctrl+MINUS change_font_size all -1
      map ctrl+0 change_font_size all 0

      clipboard_control write-clipboard write-primary no-append
      confirm_os_window_close 0
      enable_audio_bell no
      modify_font underline_position +3
      placement_strategy top-left
      shell_integration no-title
      window_margin_width 6

      ${colorschemeConf}

      include ${config.home.homeDirectory}/.config/kitty/kitty.local.conf
    '';
  };
}
