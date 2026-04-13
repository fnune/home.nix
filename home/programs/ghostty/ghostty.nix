{
  config,
  lib,
  pkgs,
  ...
}: let
  themeDir = "${config.home.homeDirectory}/.local/share/nvim/lazy/standard/ghostty";
  useStandard = config.colorscheme == "standard";
in {
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
        confirm-close-surface = false
        shell-integration-features = no-title
      ''
      + lib.optionalString useStandard "theme = standard\n";
  };
}
