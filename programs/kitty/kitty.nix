{config, ...}: {
  home.file.".config/kitty/kitty.conf".text = ''
    map ctrl+PLUS change_font_size all +1
    map ctrl+MINUS change_font_size all -1
    map ctrl+0 change_font_size all 0

    clipboard_control write-clipboard write-primary no-append
    confirm_os_window_close 0
    enable_audio_bell no
    mouse_hide_wait 1
    placement_strategy top-left
    hide_window_decorations yes
    include ${config.home.homeDirectory}/.config/kitty/kitty.local.conf
  '';
}
