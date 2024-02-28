{
  config,
  pkgs,
  ...
}: {
  home.packages = [pkgs.unstable.kitty];

  home.file.".config/kitty/kitty.conf".text = ''
    shell ${config.shell.bin} ${pkgs.lib.concatStringsSep " " config.shell.args}

    map ctrl+PLUS change_font_size all +1
    map ctrl+MINUS change_font_size all -1
    map ctrl+0 change_font_size all 0

    clipboard_control write-clipboard write-primary no-append
    confirm_os_window_close 0
    enable_audio_bell no
    mouse_hide_wait 1
    placement_strategy top-left
    hide_window_decorations yes
    include ${config.home.homeDirectory}/.local/share/nvim/lazy/vscode.nvim/extra/kitty/vscode-dark.conf
    include ${config.home.homeDirectory}/.config/kitty/kitty.local.conf
  '';
}
