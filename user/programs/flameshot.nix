{
  pkgs,
  config,
  ...
}: let
  screenshots = "${config.home.homeDirectory}/Pictures/Screenshots";
in {
  services.flameshot.enable = true;
  services.flameshot.settings = {
    General = {
      checkForUpdates = false;
      contrastOpacity = 188;
      contrastUiColor = "#ffffff";
      copyPathAfterSave = true;
      disabledTrayIcon = true;
      drawColor = "#ff0000";
      filenamePattern = "%F_%T_screenshot";
      saveAfterCopy = true;
      saveAsFileExtension = ".png";
      savePath = screenshots;
      savePathFixed = true;
      showDesktopNotification = false;
      showHelp = false;
      showSidePanelButton = false;
      showStartupLaunchMessage = false;
      startupLaunch = true;
      uiColor = "#ffffff";
    };
  };

  dconf.settings = {
    "org/gnome/shell/keybindings" = {
      "screenshot" = [];
      "screenshot-window" = [];
      "show-screenshot-ui" = [];
    };

    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/screenshot-full" = {
      "binding" = "Print";
      "command" = "${pkgs.flameshot}/bin/flameshot full -c -p ${screenshots}";
      "name" = "flameshot full";
    };

    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/screenshot-area" = {
      "binding" = "<Shift>Print";
      "command" = "${pkgs.flameshot}/bin/flameshot gui";
      "name" = "flameshot gui";
    };
  };
}
