{
  config,
  lib,
  pkgs,
  ...
}: let
  extensions = with pkgs.gnomeExtensions; [
    appindicator
    caffeine
    no-overview
    pano
    tiling-assistant
  ];
  extensionsBuiltIn = [
    "auto-move-windows@gnome-shell-extensions.gcampax.github.com"
    "drive-menu@gnome-shell-extensions.gcampax.github.com"
  ];
  cursor = {
    name = "Simp1e-Adw-Dark";
    size = builtins.ceil config.machine.scale * 24;
    package = pkgs.simp1e-cursors;
  };
  editLatestScreenshot = pkgs.writeShellScriptBin "edit-latest-screenshot" ''
    LATEST_SCREENSHOT=$(ls -1v "${config.home.homeDirectory}/Pictures/Screenshots/"*.png | tail -n 1)
    ${pkgs.pinta}/bin/pinta "$LATEST_SCREENSHOT"
  '';
in {
  home.packages = extensions ++ [pkgs.pinta];

  gtk.cursorTheme = cursor;
  home.pointerCursor = cursor;

  # Using dconf settings to set these does not work. Since dconf from within
  # the Nix store does not share the user's D-Bus session, I need to resort to
  # assuming that the host system provides gsettings.
  home.activation.configureKeyboardRepeat = lib.hm.dag.entryAfter ["writeBoundary"] ''
    gsettings=$(command -v /usr/bin/gsettings || command -v /run/current-system/sw/bin/gsettings)
    "$gsettings" set org.gnome.desktop.peripherals.keyboard delay 200
    "$gsettings" set org.gnome.desktop.peripherals.keyboard repeat-interval 30
  '';

  # They don't get picked up in non-NixOS systems. Help out my Debian by symlinking.
  home.activation.symlinkGnomeExtensions = lib.hm.dag.entryAfter ["writeBoundary"] ''
    set -euo pipefail
    src="${config.home.profileDirectory}/share/gnome-shell/extensions"
    dest="${config.home.homeDirectory}/.local/share/gnome-shell/extensions"
    mkdir -p ${config.home.homeDirectory}/.local/share/gnome-shell
    rm -rf "$dest"; ln -sf "$src" "$dest"
  '';

  dconf.settings = {
    "org/gnome/shell" = {
      "enabled-extensions" = (map (extension: extension.extensionUuid) extensions) ++ extensionsBuiltIn;
      "disabled-extensions" = [];
      "disable-user-extensions" = false;
    };

    "org/gnome/desktop/input-sources" = {
      "xkb-options" = ["caps:escape" "compose:rwin"];
    };

    "org/gnome/shell/app-switcher" = {
      "current-workspace-only" = true;
    };

    "org/gnome/desktop/interface" = {
      "clock-show-date" = true;
      "clock-show-weekday" = true;
      "cursor-size" = 32;
      "enable-hot-corners" = false;
      "icon-theme" = "Adwaita";
      "show-battery-percentage" = true;
    };

    "org/gnome/desktop/calendar" = {
      "show-weekdate" = true;
    };

    "org/gnome/mutter" = {
      "edge-tiling" = true;
      "dynamic-workspaces" = false;
      "overlay-key" = "";
      "center-new-windows" = true;
    };

    "org/gnome/desktop/wm/preferences" = {
      "focus-mode" = "click";
      "num-workspaces" = 10;
    };

    "org/gnome/shell/keybindings" = {
      "switch-to-application-1" = [];
      "switch-to-application-2" = [];
      "switch-to-application-3" = [];
      "switch-to-application-4" = [];
      "switch-to-application-5" = [];
      "switch-to-application-6" = [];
      "switch-to-application-7" = [];
      "switch-to-application-8" = [];
      "switch-to-application-9" = [];
      "switch-to-application-10" = [];

      "toggle-overview" = ["<Super>d"];

      "screenshot" = ["Print"];
      "show-screenshot-ui" = ["<Shift>Print"];
    };

    "org/gnome/desktop/wm/keybindings" = {
      "maximize" = [];
      "minimize" = [];

      "move-to-workspace-down" = [];
      "move-to-workspace-last" = [];
      "move-to-workspace-left" = [];
      "move-to-workspace-right" = [];
      "move-to-workspace-up" = [];

      "switch-to-workspace-down" = [];
      "switch-to-workspace-last" = [];
      "switch-to-workspace-left" = [];
      "switch-to-workspace-right" = [];
      "switch-to-workspace-up" = [];

      "close" = ["<Super><Shift>Q"];

      "switch-to-workspace-1" = ["<Super>1"];
      "switch-to-workspace-2" = ["<Super>2"];
      "switch-to-workspace-3" = ["<Super>3"];
      "switch-to-workspace-4" = ["<Super>4"];
      "switch-to-workspace-5" = ["<Super>5"];
      "switch-to-workspace-6" = ["<Super>6"];
      "switch-to-workspace-7" = ["<Super>7"];
      "switch-to-workspace-8" = ["<Super>8"];
      "switch-to-workspace-9" = ["<Super>9"];
      "switch-to-workspace-10" = ["<Super>0"];

      "move-to-workspace-1" = ["<Super><Shift>1"];
      "move-to-workspace-2" = ["<Super><Shift>2"];
      "move-to-workspace-3" = ["<Super><Shift>3"];
      "move-to-workspace-4" = ["<Super><Shift>4"];
      "move-to-workspace-5" = ["<Super><Shift>5"];
      "move-to-workspace-6" = ["<Super><Shift>6"];
      "move-to-workspace-7" = ["<Super><Shift>7"];
      "move-to-workspace-8" = ["<Super><Shift>8"];
      "move-to-workspace-9" = ["<Super><Shift>9"];
      "move-to-workspace-10" = ["<Super><Shift>0"];

      "toggle-maximized" = ["<Super>f"];
      "toggle-fullscreen" = ["<Super><Shift>F"];

      "switch-applications" = [];
      "switch-applications-backward" = [];
      "switch-windows" = ["<Alt>Tab"];
      "switch-windows-backward" = ["<Shift><Alt>Tab"];
    };

    # Declare the available custom keybindings and let applications (kitty) define them.
    "org/gnome/settings-daemon/plugins/media-keys" = {
      "custom-keybindings" = [
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/terminal/"
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/edit-latest-screenshot/"
      ];
    };

    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/edit-latest-screenshot" = {
      "binding" = "<Ctrl>Print";
      "command" = "${editLatestScreenshot}/bin/edit-latest-screenshot";
      "name" = "Edit the latest screenshot";
    };

    "org/gnome/settings-daemon/plugins/media-keys" = {
      "screensaver" = [];
    };

    "org/gnome/shell/extensions/space-bar/shortcuts" = {
      "enable-activate-workspace-shortcuts" = false;
      "enable-move-to-workspace-shortcuts" = false;
    };

    "org/gnome/shell/extensions/space-bar/appearance" = {
      "workspaces-bar-padding" = 0;
    };

    "org/gnome/desktop/notifications/application/org-gnome-extensions-desktop" = {
      "enable" = false;
    };

    "org/gnome/settings-daemon/plugins/color" = {
      "night-light-enabled" = true;
      "night-light-schedule-automatic" = true;
      "night-color-light-temperature" = 3500;
    };

    "org/gnome/system/location" = {
      "enabled" = true;
    };

    "org/gnome/desktop/peripherals/touchpad" = {
      "tap-to-click" = true;
    };

    "org/gnome/desktop/peripherals/mouse" = {
      "natural-scroll" = false;
      "accel-profile" = "flat";
    };

    "org/gnome/shell/extensions/tiling-assistant" = {
      "active-window-hint" = 0;
      "dynamic-keybinding-behavior" = 1;
      "restore-window" = ["<Super>e"];
      "single-screen-gap" = 12;
      "tile-bottom-half" = ["<Super>j"];
      "tile-left-half" = ["<Super>h"];
      "tile-right-half" = ["<Super>l"];
      "tile-top-half" = ["<Super>k"];
      "window-gap" = 12;
    };

    "org/gnome/shell/extensions/pano" = {
      "history-length" = 500;
      "play-audio-on-copy" = false;
      "send-notification-on-copy" = false;
    };

    "org/gnome/shell/extensions/caffeine" = {
      "show-notifications" = false;
    };

    "org/gnome/shell/extensions/auto-move-windows" = {
      "application-list" = [
        "firefox-developer-edition.desktop:1"
        "firefox.desktop:4"
        "signal-desktop.desktop:6"
        "thunderbird.desktop:6"
        "slack.desktop:7"
        "Zoom.desktop:8"
        "spotify.desktop:9"
        "com.obsproject.Studio.desktop:10"
      ];
    };
  };
}
