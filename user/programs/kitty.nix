{
  config,
  pkgs,
  ...
}: let
  rosePineUrl = "https://raw.githubusercontent.com/rose-pine/kitty/788bf1b/dist/rose-pine.conf";
  rosePineConf = pkgs.fetchurl {
    url = rosePineUrl;
    sha256 = "sha256-D+eGb2KNmgZ6b5XSReIpyA+bnzn5xyOrhz6trmbmNO0";
  };
  colorschemeConf =
    if config.colorscheme == "vscode"
    then "include ${config.home.homeDirectory}/.local/share/nvim/lazy/vscode.nvim/extra/kitty/vscode-dark.conf"
    else if config.colorscheme == "rose-pine"
    then "include ${rosePineConf}"
    else "";
in {
  home.packages = [pkgs.unstable.kitty];
  home.file.".config/kitty/kitty.conf".text = ''
    shell ${config.shell.bin} ${pkgs.lib.concatStringsSep " " config.shell.args}

    map ctrl+PLUS change_font_size all +1
    map ctrl+MINUS change_font_size all -1
    map ctrl+0 change_font_size all 0

    clipboard_control write-clipboard write-primary no-append
    confirm_os_window_close 0
    enable_audio_bell no
    placement_strategy top-left
    hide_window_decorations yes

    ${colorschemeConf}

    include ${config.home.homeDirectory}/.config/kitty/kitty.local.conf
  '';
}
