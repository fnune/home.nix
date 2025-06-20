{
  pkgs,
  config,
  ...
}: {
  imports = [./palette.nix ./panel.nix];

  home.packages =
    (with pkgs; [
      haruna
      libreoffice-qt
    ])
    ++ (with pkgs.kdePackages; [
      filelight
      isoimagewriter
      kalk
      kcharselect
      kclock
      kcolorchooser
      kjournald
      krohnkite
      kweather
    ]);

  gtk.cursorTheme = config.cursors;
  home.pointerCursor = config.cursors;

  programs.plasma = {
    enable = true;
    fonts = let
      fontSize = 11;
      fontSizeSmall = 9;
      monoFontSize = 9;
      sans = {
        family = config.fontconfig.sans;
        weight = "medium";
        pointSize = fontSize;
      };
      sansBold = {
        family = config.fontconfig.sans;
        weight = "bold";
        pointSize = fontSize;
      };
      sansSmall = {
        family = config.fontconfig.sans;
        weight = "medium";
        pointSize = fontSizeSmall;
      };
      mono = {
        family = config.fontconfig.mono;
        pointSize = monoFontSize;
      };
    in {
      general = sans;
      menu = sans;
      toolbar = sans;
      windowTitle = sansBold;
      small = sansSmall;
      fixedWidth = mono;
    };
    desktop = {
      mouseActions = {
        middleClick = null;
      };
    };
    workspace = {
      wallpaper = "${pkgs.kdePackages.plasma-workspace-wallpapers}/share/wallpapers/SafeLanding";
    };
    kscreenlocker = {
      appearance = {
        wallpaperPlainColor = "33,33,33";
      };
    };
    shortcuts = {
      "services/${config.terminal.name}.desktop"."_launch" = "Meta+Return";
      "services/${config.browser.name}.desktop"."new-window" = "Meta+Shift+Return";

      "org.kde.krunner.desktop"."_launch" = "Meta+D";
      "org.kde.plasma.emojier.desktop"."_launch" = "Meta+.";
      "org.kde.spectacle.desktop" = {
        "ActiveWindowScreenShot" = "Meta+Print";
        "FullScreenScreenShot" = "Print";
        "RectangularRegionScreenShot" = "Shift+Print";
      };

      "plasmashell" = {
        "toggle do not disturb" = "Meta+N";

        # Gets annoying in light of my Meta+D krunner shortcut
        "activate application launcher" = [];

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
        "Window Minimize" = ""; # Accidental minimize is annoying
        "Show Desktop" = ""; # Clashes with application launcher
        "Peek at Desktop" = ""; # Clashes with application launcher

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
        "Window Maximize" = "Meta+F";

        "KrohnkiteFocusDown" = "Meta+J";
        "KrohnkiteFocusLeft" = "Meta+H";
        "KrohnkiteFocusRight" = "Meta+L";
        "KrohnkiteFocusUp" = "Meta+K";

        "KrohnkiteShiftDown" = "Meta+Shift+J";
        "KrohnkiteShiftLeft" = "Meta+Shift+H";
        "KrohnkiteShiftRight" = "Meta+Shift+L";
        "KrohnkiteShiftUp" = "Meta+Shift+K";

        "KrohnkiteToggleFloat" = "Meta+Space";
        "KrohnkiteToggleFloatAll" = "Meta+Shift+Space";
        "KrohnkitegrowWidth" = "Meta+*"; # Lowercase 'g' is not a typo of this config
        "KrohnkiteShrinkWidth" = "Meta+_";

        "ToggleMouseClick" = "Meta+Ctrl+.";
      };

      "ksmserver"."Lock Session" = [];
    };

    configFile = {
      "breezerc" = {
        "Common" = {
          "ShadowSize".value = "ShadowLarge";
          "ShadowStrength".value = 215;
        };

        "Style" = {
          "ToolBarDrawItemSeparator".value = false;
        };

        "Windeco" = {
          "ButtonSize".value = "ButtonSmall";
        };
      };

      "plasmaparc" = {
        "General" = {
          "RaiseMaximumVolume".value = true;
        };
      };

      "spectaclerc" = {
        "General" = {
          "autoSaveImage".value = true;
          "clipboardGroup".value = "PostScreenshotCopyImage";
          "showCaptureInstructions".value = false;
        };
      };

      "kcminputrc" = {
        "Mouse"."cursorSize".value = config.cursors.size;
        "Mouse"."cursorTheme".value = config.cursors.name;
        "Keyboard" = {
          "RepeatDelay".value = 200;
          "RepeatRate".value = 30;
        };
      };

      "kdeglobals" = {
        "General" = {
          "AccentColor" = config.accent.rgb;
          "BrowserApplication" = "${config.browser.name}.desktop";
          "TerminalApplication" = config.terminal.name;
          "TerminalService" = "${config.terminal.name}.service";
          "XftAntialias".value = config.fontconfig.antialias;
          "XftHintStyle".value = config.fontconfig.hinting;
          "XftSubPixel".value = config.fontconfig.subpixel;
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
        "Desktops"."Number".value = 10;
        "Desktops"."Rows".value = 1;

        "NightColor" = {
          "Active".value = true;
          "NightTemperature".value = 3600;
        };

        "Plugins" = {
          "hidecursorEnabled".value = true;
        };

        "Effect-hidecursor" = {
          "HideOnTyping" = false; # https://bugs.kde.org/show_bug.cgi?id=490528
          "InactivityDuration" = 3;
        };

        "Effect-zoom" = {
          "ZoomFactor" = 1.05;
        };

        "Effect-slide" = {
          "HorizontalGap".value = 0;
          "SlideBackground".value = false;
          "VerticalGap".value = 0;
        };

        "Effect-mouseclick" = {
          "Color1" = "160,160,160";
          "Color2" = "255,0,0";
          "Color3" = "255,128,128";
          "LineWidth" = 2;
          "RingCount" = 1;
          "RingLife" = 200;
          "RingSize" = 50;
          "ShowText" = false;
        };

        "org.kde.kdecoration2" = {
          "ButtonsOnLeft" = "M"; # Application icon & "more actions"
          "ButtonsOnRight" = "X"; # Just the close button
        };

        "Plugins" = {
          "krohnkiteEnabled".value = true;
        };
        "Script-krohnkite" = let
          gap = builtins.floor (9 * config.machine.scale);
        in {
          "enableFloatingLayout".value = true;
          "enableTileLayout".value = true;
          "floatingClass".value =
            builtins.concatStringsSep ","
            [
              "kcmshell6"
              "org.freedesktop.impl.portal.desktop.kde"
              "org.kde.bluedevilwizard"
              "org.kde.dolphin"
              "org.kde.isoimagewriter"
              "org.kde.kcharselect"
              "org.kde.kclock"
              "org.kde.kded6"
              "org.kde.partitionmanager"
              "org.kde.plasma.emojier"
              "systemsettings"
              "zoom"
            ];

          # NB: the Plasma panel is layer 1
          "tiledWindowsLayer".value = 1;
          "floatedWindowsLayer".value = 1;

          "enableBTreeLayout".value = false;
          "enableColumnsLayout".value = false;
          "enableMonocleLayout".value = false;
          "enableSpiralLayout".value = false;
          "enableSpreadLayout".value = false;
          "enableStairLayout".value = false;
          "enableThreeColumnLayout".value = false;

          "screenGapBetween".value = gap;
          "screenGapBottom".value = gap;
          "screenGapLeft".value = gap;
          "screenGapRight".value = gap;
          "screenGapTop".value = gap;
          "tileLayoutGap".value = gap;
        };
      };

      "kxkbrc" = {
        "Layout" = {
          "Options".value = "caps:escape,compose:rwin";
          "ResetOldOptions".value = true;
        };
      };

      "plasma-localerc" = {
        "Formats" = builtins.mapAttrs (name: value: {inherit value;}) (import ../../locales.nix);
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
        "Plugins/Favorites" = {
          "plugins".value = "krunner_placesrunner,krunner_services,krunner_sessions,krunner_systemsettings";
        };
        "Plugins" = {
          "baloosearchEnabled" = true;
          "browserhistoryEnabled" = true;
          "browsertabsEnabled" = true;
          "desktopsessionsEnabled" = true;
          "krunner_servicesEnabled" = true;
          "krunner_sessionsEnabled" = true;
          "krunner_systemsettingsEnabled" = true;
          # Disabled:
          "appstreamEnabled" = false;
          "bookmarksEnabled" = false;
          "helprunnerEnabled" = false;
          "katesessionsEnabled" = false;
          "konsoleprofilesEnabled" = false;
          "krunner_appstreamEnabled" = false;
          "krunner_katesessionsEnabled" = false;
          "krunner_konsoleprofilesEnabled" = false;
          "krunner_webshortcutsEnabled" = false;
          "org.kde.activities2Enabled" = false;
          "org.kde.windowedwidgetsEnabled" = false;
          "webshortcutsEnabled" = false;
          "windowsEnabled" = false;
        };
      };

      "dolphinrc" = {
        "General" = {
          "EditableUrl" = false;
          "ShowSelectionToggle" = false;
        };
      };

      "haruna/haruna.conf" = {
        "General" = {
          "ShowHeader".value = false;
          "ShowMenuBar".value = false;
        };
        "Playlist" = {
          "CanToggleWithMouse".value = false;
        };
      };
    };
  };
}
