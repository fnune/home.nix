{
  config,
  pkgs,
  ...
}: let
  colorschemeConf =
    if config.colorscheme == "standard"
    then "include ${config.home.homeDirectory}/.local/share/nvim/lazy/standard/kitty/standard.dark.conf"
    else "";
  icon = ./whiskers.png;
in {
  services.pacman.packages = ["kitty"];

  home.file = {
    ".local/share/applications/kitty.desktop".text = ''
      [Desktop Entry]
      Version=1.0
      Type=Application
      Name=kitty
      GenericName=Terminal emulator
      Comment=Fast, feature-rich, GPU based terminal
      TryExec=kitty
      StartupNotify=true
      Exec=kitty
      Icon=${icon}
      Categories=System;TerminalEmulator;
      X-TerminalArgExec=--
      X-TerminalArgTitle=--title
      X-TerminalArgAppId=--class
      X-TerminalArgDir=--working-directory
      X-TerminalArgHold=--hold
    '';
    ".config/kitty/kitty.conf".text = ''
      shell ${config.shell.bin} ${pkgs.lib.concatStringsSep " " config.shell.args}

      clear_all_shortcuts yes
      map ctrl+plus change_font_size all +1
      map ctrl+minus change_font_size all -1
      map ctrl+0 change_font_size all 0
      map ctrl+shift+v paste_from_clipboard
      map ctrl+shift+c copy_to_clipboard

      allow_remote_control no
      clipboard_control write-clipboard write-primary no-append
      confirm_os_window_close 0
      detect_urls yes
      enable_audio_bell no
      modify_font underline_position +3
      placement_strategy top-left
      shell_integration no-title
      tab_bar_style hidden
      window_margin_width 6

      ${colorschemeConf}

      include ${config.home.homeDirectory}/.config/kitty/kitty.local.conf
    '';
  };
}
