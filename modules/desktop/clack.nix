{config, ...}: {
  programs.clack = {
    enable = true;
    desktop.enable = true;

    settings = {
      overlay = {
        font = "${config.fontconfig.sans} 36";
        margin = 96;
        anchor = "bottom";
        timeout_seconds = 1.5;
        symbols = false;
        symbol_overrides = {};
      };

      desktop = {
        start_hidden = false;
        start_overlay = false;
        decorations = false;
      };
    };
  };
}
