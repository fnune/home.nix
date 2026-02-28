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
