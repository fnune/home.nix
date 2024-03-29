{
  pkgs,
  config,
  ...
}: let
  cursor = {
    name = "Simp1e-Adw-Dark";
    size = 32;
    package = pkgs.simp1e-cursors;
  };
in {
  home.packages = [pkgs.dconf pkgs.pantheon.elementary-wallpapers pkgs.libsForQt5.kclock];

  gtk.cursorTheme = cursor;
  home.pointerCursor = cursor;

  programs.plasma = {
    enable = true;
    shortcuts = {
      "${config.terminal.name}.desktop"."_launch" = "Meta+Return";

      "org.kde.krunner.desktop"."_launch" = "Meta+D";
      "org.kde.plasma.emojier.desktop"."_launch" = "Meta+.";
      "org.kde.spectacle.desktop" = {
        "ActiveWindowScreenShot" = "Meta+Print";
        "FullScreenScreenShot" = "Print";
        "RectangularRegionScreenShot" = "Shift+Print";
      };

      "plasmashell" = {
        "toggle do not disturb" = "Meta+N";

        # These clash with my Switch to Desktop shortcuts
        "activate task manager entry 1" = [];
        "activate task manager entry 2" = [];
        "activate task manager entry 3" = [];
        "activate task manager entry 4" = [];
        "activate task manager entry 5" = [];
        "activate task manager entry 6" = [];
        "activate task manager entry 7" = [];
        "activate task manager entry 8" = [];
        "activate task manager entry 9" = [];
        "activate task manager entry 10" = [];
      };
      "kwin" = {
        "Show Desktop" = []; # Clashes with krunner shortcut

        "Switch to Desktop 1" = "Meta+1";
        "Switch to Desktop 2" = "Meta+2";
        "Switch to Desktop 3" = "Meta+3";
        "Switch to Desktop 4" = "Meta+4";
        "Switch to Desktop 5" = "Meta+5";
        "Switch to Desktop 6" = "Meta+6";
        "Switch to Desktop 7" = "Meta+7";
        "Switch to Desktop 8" = "Meta+8";
        "Switch to Desktop 9" = "Meta+9";
        "Switch to Desktop 10" = "Meta+0";

        "Window to Desktop 1" = "Meta+!";
        "Window to Desktop 2" = "Meta+\"";
        "Window to Desktop 3" = "Meta+·";
        "Window to Desktop 4" = "Meta+$";
        "Window to Desktop 5" = "Meta+%";
        "Window to Desktop 6" = "Meta+&";
        "Window to Desktop 7" = "Meta+/";
        "Window to Desktop 8" = "Meta+(";
        "Window to Desktop 9" = "Meta+)";
        "Window to Desktop 10" = "Meta+=";

        "Walk Through Windows" = "Alt+Tab";
        "Walk Through Windows (Reverse)" = "Alt+Shift+Backtab";
        "Walk Through Windows of Current Application" = []; # Clashes with Firefox tab shortcut
        "Walk Through Windows of Current Application (Reverse)" = []; # Clashes with Firefox tab shortcut

        "Window Close" = "Meta+Shift+Q";
        "Window Fullscreen" = "Meta+Shift+F";
        "Window Maximize" = "Meta+F"; # Clashes with Window Quick Tile Right

        "Window Quick Tile Bottom" = "Meta+J";
        "Window Quick Tile Left" = "Meta+H";
        "Window Quick Tile Right" = "Meta+L";
        "Window Quick Tile Top" = "Meta+K";

        "view_zoom_in" = [];
        "view_zoom_out" = [];
      };

      "ksmserver"."Lock Session" = [];
    };

    configFile = {
      "kcminputrc" = {
        "Mouse"."cursorSize".value = cursor.size;
        "Mouse"."cursorTheme".value = cursor.name;
        "Keyboard" = {
          "RepeatDelay".value = 200;
          "RepeatRate".value = 30;
        };
      };

      "kdeglobals" = {
        "KScreen"."ScaleFactor".value = config.machine.scale;
        "General" = {
          "font".value = "Inter,12,-1,5,500,0,0,0,0,0,0,0,0,0,0,1,Medium";
          "menuFont".value = "Inter,12,-1,5,400,0,0,0,0,0,0,0,0,0,0,1";
          "smallestReadableFont".value = "Inter,10,-1,5,500,0,0,0,0,0,0,0,0,0,0,1,Medium";
          "toolBarFont".value = "Inter,12,-1,5,400,0,0,0,0,0,0,0,0,0,0,1";
        };
        "WM" = {
          "activeFont".value = "Inter,12,-1,5,600,0,0,0,0,0,0,0,0,0,0,1,Semi Bold";
        };
        "KDE" = {
          "AnimationDurationFactor".value = 0.27;
          "ShowIconsInMenuItems".value = false;
        };
      };

      "ksmserverrc" = {
        "General" = {
          "loginMode".value = "emptySession";
        };
      };

      "kwinrc" = {
        "Xwayland"."Scale".value = config.machine.scale;
        "Desktops"."Number".value = 10;
        "Desktops"."Rows".value = 1;

        "Effect-slide"."HorizontalGap".value = 0;
        "Effect-slide"."SlideBackground".value = false;
        "Effect-slide"."VerticalGap".value = 0;

        "NightColor" = {
          "Active".value = true;
          "NightTemperature".value = 3600;
        };

        "Wayland" = {
          # I don't like this but it fixes a Firefox address bar clipboard bug:
          # https://bugzilla.mozilla.org/show_bug.cgi?id=1791417
          "EnablePrimarySelection".value = true;
        };

        "Xwayland" = {
          # Let Xwayland apps access some global shortcut combinations:
          "XwaylandEavesdrops".value = "Combinations";
        };
      };

      "kxkbrc" = {
        "Layout" = {
          "Options".value = "caps:escape,compose:rwin";
          "ResetOldOptions".value = true;
        };
      };

      "plasma-localerc" = {
        "Formats" = builtins.mapAttrs (name: value: {value = value;}) (import ../locales.nix);
        "Translations" = {
          "LANGUAGE".value = "en_US";
        };
      };

      "ksplashrc" = {
        "KSplash" = {
          "Engine".value = "none";
        };
      };

      "klaunchrc" = {
        "FeedbackStyle" = {
          "BusyCursor".value = false;
        };
      };

      "krunnerrc" = {
        "General" = {
          "FreeFloating".value = true;
        };
        "Plugins" = {
          "appstreamEnabled".value = false;
          "bookmarksEnabled".value = false;
          "browserhistoryEnabled".value = false;
          "browsertabsEnabled".value = false;
          "desktopsessionsEnabled".value = true;
          "helprunnerEnabled".value = false;
          "katesessionsEnabled".value = false;
          "konsoleprofilesEnabled".value = false;
          "org.kde.activities2Enabled".value = false;
          "org.kde.windowedwidgetsEnabled".value = false;
          "webshortcutsEnabled".value = false;
        };
      };
    };
  };
}
