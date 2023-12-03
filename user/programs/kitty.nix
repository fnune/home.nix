{
  config,
  pkgs,
  ...
}: {
  home.packages = [pkgs.kitty];

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

  dconf.settings = {
    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/terminal" = {
      "binding" = "<Super>Return";
      "command" = "kitty";
      "name" = "kitty";
    };
  };

  # https://github.com/espanso/espanso/issues/281
  services.espanso.configs.kitty = {
    filter_class = "kitty";
    disable_x11_fast_inject = true;
  };
}
