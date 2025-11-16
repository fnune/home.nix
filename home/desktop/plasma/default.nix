{config, ...}: {
  imports = [./window-rules.nix];

  services.pacman.packages = [
    "flatpak"
    "haruna"
    "isoimagewriter"
    "kalk"
    "kcharselect"
    "kclock"
    "kcolorchooser"
    "ksshaskpass"
    "kweather"
    "libreoffice-fresh"
    "pdfarranger"
  ];

  programs.plasma = {
    enable = true;
    fonts = let
      fontSize = 11;
      fontSizeSmall = 9;
      monoFontSize = 9;
    in {
      general = {
        family = config.fontconfig.sans;
        weight = "medium";
        pointSize = fontSize;
      };
      menu = {
        family = config.fontconfig.sans;
        weight = "medium";
        pointSize = fontSize;
      };
      toolbar = {
        family = config.fontconfig.sans;
        weight = "medium";
        pointSize = fontSize;
      };
      windowTitle = {
        family = config.fontconfig.sans;
        weight = "bold";
        pointSize = fontSize;
      };
      small = {
        family = config.fontconfig.sans;
        weight = "medium";
        pointSize = fontSizeSmall;
      };
      fixedWidth = {
        family = config.fontconfig.mono;
        pointSize = monoFontSize;
      };
    };

    workspace = {
      theme = "breeze-dark";
      colorScheme = "BreezeDark";
      wallpaperFillMode = "preserveAspectCrop";
      splashScreen = {
        engine = "none";
        theme = "none";
      };
      cursor = {
        inherit (config.cursors) size;
        theme = config.cursors.name;
      };
    };

    desktop = {
      mouseActions = {
        middleClick = null;
      };
    };

    kwin = {
      virtualDesktops = {
        number = 10;
        rows = 1;
      };
      borderlessMaximizedWindows = true;
      effects = {
        blur.enable = true;
      };
      titlebarButtons = {
        left = ["more-window-actions"];
        right = ["close"];
      };
    };

    input = {
      keyboard = {
        repeatDelay = 200;
        repeatRate = 30;
        options = ["caps:escape" "compose:rwin"];
      };
    };

    krunner = {
      position = "center";
    };

    spectacle = {
      shortcuts = {
        captureActiveWindow = "Meta+Print";
        captureEntireDesktop = "Print";
        captureRectangularRegion = "Shift+Print";
      };
    };

    kscreenlocker = {
      appearance = {
        wallpaperPlainColor = "33,33,33";
      };
    };

    shortcuts = {
      "services/${config.terminal.name}.desktop"."_launch" = "Meta+Return";
      "services/${config.browser.name}.desktop"."_launch" = "Meta+Shift+Return";

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

        # I don't use this
        "manage activities" = [];
      };
      "kwin" = {
        "Window Minimize" = ""; # Accidental minimize is annoying
        "Show Desktop" = ""; # Clashes with application launcher
        "Peek at Desktop" = ""; # Clashes with application launcher
        "Edit Tiles" = ""; # Just confusing

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

        "Window Quick Tile Bottom" = "Meta+Shift+J";
        "Window Quick Tile Left" = "Meta+Shift+H";
        "Window Quick Tile Right" = "Meta+Shift+L";
        "Window Quick Tile Top" = "Meta+Shift+K";

        "Switch Window Down" = "Meta+j";
        "Switch Window Left" = "Meta+h";
        "Switch Window Right" = "Meta+l";
        "Switch Window Up" = "Meta+k";

        "view_actual_size" = "Meta+Ctrl+0";
        "view_zoom_in" = "Meta+Ctrl++";
        "view_zoom_out" = "Meta+Ctrl+-";

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
        "NightColor" = {
          "Active".value = true;
          "NightTemperature".value = 3600;
        };

        "Plugins" = {
          "blurEnabled".value = true;
          "desktopchangeosdEnabled".value = false;
          "hidecursorEnabled".value = true;
          "mouseclickEnabled".value = true;
        };

        "Effect-hidecursor" = {
          "HideOnTyping" = true;
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
      };

      "kxkbrc" = {
        "Layout" = {
          "ResetOldOptions".value = true;
        };
      };

      "plasma-localerc" = {
        "Formats" = builtins.mapAttrs (name: value: {inherit value;}) (import ../../locales.nix);
        "Translations" = {
          "LANGUAGE".value = "en_US";
        };
      };

      "klaunchrc" = {
        "FeedbackStyle" = {
          "BusyCursor".value = false;
        };
      };

      "krunnerrc" = {
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
          "DynamicView" = true;
          "EditableUrl" = false;
          "GlobalViewProps" = false;
          "ShowSelectionToggle" = false;
          "ViewMode" = 2;
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
