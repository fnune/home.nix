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
    then "include ${config.home.homeDirectory}/.local/share/nvim/lazy/vscode/extra/kitty/vscode-dark.conf"
    else if config.colorscheme == "rose-pine"
    then "include ${rosePineConf}"
    else "";
in {
  nixpkgs.overlays = [
    (final: prev: {
      kittyWithWhiskers = final.unstable.kitty.overrideAttrs (o: {
        postInstall =
          (o.postInstall or "")
          + ''
            cp -f ${./whiskers.png} $out/share/icons/hicolor/256x256/apps/kitty.png
            cp -f ${./whiskers.svg} $out/share/icons/hicolor/scalable/apps/kitty.svg
          '';
      });
    })
  ];
  home.packages = with pkgs; [kittyWithWhiskers];
  home.file.".config/kitty/kitty.conf".text = ''
    shell ${config.shell.bin} ${pkgs.lib.concatStringsSep " " config.shell.args}

    map ctrl+PLUS change_font_size all +1
    map ctrl+MINUS change_font_size all -1
    map ctrl+0 change_font_size all 0

    clipboard_control write-clipboard write-primary no-append
    confirm_os_window_close 0
    enable_audio_bell no
    placement_strategy top-left
    hide_window_decorations no
    symbol_map U+002A BlexMono Nerd Font

    ${colorschemeConf}

    include ${config.home.homeDirectory}/.config/kitty/kitty.local.conf
  '';
}
