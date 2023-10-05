{pkgs, ...}: let
  cursor = {
    name = "Simp1e-Adw-Dark";
    size = 48; # FIXME: Hardware-dependent
    package = pkgs.simp1e-cursors;
  };
in {
  home.packages = [pkgs.dconf];

  gtk.cursorTheme = cursor;
  home.pointerCursor = cursor;

  programs.plasma = {
    enable = true;
    workspace.clickItemTo = "select";
    shortcuts = {
      "kitty.desktop"."_launch" = "Meta+Return";

      "org.kde.krunner.desktop"."_launch" = "Meta+D";
      "org.kde.plasma.emojier.desktop"."_launch" = "Meta+.";
      "org.kde.spectacle.desktop" = {
        "ActiveWindowScreenShot" = "Meta+Print";
        "FullScreenScreenShot" = "Print";
        "RectangularRegionScreenShot" = "Shift+Print";
      };

      "plasmashell" = {
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

        "Window to Desktop 1" = "Meta+!";
        "Window to Desktop 2" = "Meta+\"";
        "Window to Desktop 3" = "Meta+·";
        "Window to Desktop 4" = "Meta+$";
        "Window to Desktop 5" = "Meta+%";
        "Window to Desktop 6" = "Meta+&";
        "Window to Desktop 7" = "Meta+/";
        "Window to Desktop 8" = "Meta+(";
        "Window to Desktop 9" = "Meta+)";

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
        "Mouse"."cursorSize" = cursor.size;
        "Mouse"."cursorTheme" = cursor.name;
        "Keyboard" = {
          "RepeatDelay" = 200;
          "RepeatRate" = 30;
        };
      };

      "kdeglobals" = {
        "KScreen"."ScaleFactor" = 2; # FIXME: Hardware-dependent
        "General" = {
          "fixed" = "Monospace,10,-1,5,50,0,0,0,0,0";
          "font" = "Inter,10,-1,5,50,0,0,0,0,0";
          "menuFont" = "Inter,10,-1,5,50,0,0,0,0,0";
          "smallestReadableFont" = "Inter,8,-1,5,50,0,0,0,0,0";
          "toolBarFont" = "Inter,10,-1,5,50,0,0,0,0,0";
        };
        "KDE" = {
          "AnimationDurationFactor" = 0.18;
          "ShowIconsInMenuItems" = false;
        };
      };

      "ksmserverrc" = {
        "General" = {
          "loginMode" = "emptySession";
        };
      };

      "kwinrc" = {
        "Xwayland"."Scale" = 2; # FIXME: Hardware-dependent
        "Desktops"."Number" = 9;
        "Desktops"."Rows" = 1;

        "Effect-slide"."HorizontalGap" = 0;
        "Effect-slide"."SlideBackground" = false;
        "Effect-slide"."VerticalGap" = 0;

        "NightColor" = {
          "Active" = true;
          "NightTemperature" = 3600;
        };

        "TabBox" = {
          "LayoutName" = "thumbnail_grid";
        };

        "TabBoxAlternative" = {
          "LayoutName" = "thumbnail_grid";
        };
      };

      "kxkbrc" = {
        "Layout" = {
          "Options" = "caps:escape,compose:rwin";
          "ResetOldOptions" = true;
        };
      };

      "plasma-localerc" = {
        "Formats" = {
          "LANG" = "en_US.UTF-8";
          "LC_MONETARY" = "de_DE.UTF-8";
          "LC_NUMERIC" = "en_DK.UTF-8";
          "LC_TIME" = "en_DK.UTF-8";
        };
        "Translations" = {
          "LANGUAGE" = "en_US";
        };
      };

      "ksplashrc"."KSplash"."Engine" = "none";
    };
  };
}
