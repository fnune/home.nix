{
  config,
  lib,
  pkgs,
  ...
}: let
  themeDir = "${config.home.homeDirectory}/.local/share/nvim/lazy/standard/ghostty";
  useStandard = config.colorscheme == "standard";
in {
  # GTK 4.20+ on Wayland no longer handles dead keys without an input method framework
  # https://github.com/ghostty-org/ghostty/discussions/8899
  home.sessionVariables.GTK_IM_MODULE = "simple";

  services.pacman.packages = ["ghostty"];

  home.activation.ghosttyTheme = lib.mkIf useStandard (
    lib.hm.dag.entryAfter ["writeBoundary"] ''
      ln -sfn "${themeDir}" "${config.home.homeDirectory}/.config/ghostty/themes"
    ''
  );

  home.file = {
    ".config/ghostty/config".text =
      ''
        command = ${config.shell.bin} ${pkgs.lib.concatStringsSep " " config.shell.args}

        keybind = ctrl+plus=increase_font_size:1
        keybind = ctrl+minus=decrease_font_size:1
        keybind = ctrl+zero=reset_font_size
        # default writes screen to file, conflicts with ctrl+j (tmux) + shift for newline
        keybind = ctrl+shift+j=unbind

        clipboard-read = allow
        clipboard-write = allow
        copy-on-select = false
        confirm-close-surface = false
        shell-integration-features = no-title
        working-directory = home
      ''
      + lib.optionalString useStandard "theme = standard\n";
  };
}
