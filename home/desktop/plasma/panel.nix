{config, ...}: {
  programs.plasma.panels = [
    {
      inherit (config.panel) height;
      hiding = "normalpanel";
      lengthMode = "fit";
      location = "top";
      opacity = "adaptive";
      screen = null;
      widgets = [
        {
          name = "org.kde.plasma.marginsseparator";
        }
        {
          name = "org.kde.plasma.pager";
          config = {
            General = {
              displayedText = "Number";
            };
          };
        }
        {
          name = "org.kde.plasma.marginsseparator";
        }
        {
          name = "org.kde.plasma.icontasks";
          config = {
            General = {
              launchers = "";
              minimizeActiveTaskOnClick = false;
              showOnlyCurrentActivity = false;
              showOnlyCurrentDesktop = false;
              wheelEnabled = false;
            };
          };
        }
        {
          name = "org.kde.plasma.systemmonitor.cpu";
          config = {
            Appearance = {
              chartFace = "org.kde.ksysguard.linechart";
            };
          };
        }
        {
          name = "org.kde.plasma.marginsseparator";
        }
        {
          name = "org.kde.plasma.systemmonitor.memory";
          config = {
            Appearance = {
              chartFace = "org.kde.ksysguard.linechart";
            };
          };
        }
        {
          name = "org.kde.plasma.systemtray";
        }
        {
          name = "org.kde.plasma.weather";
          config = {
            WeatherStation = {
              source = "bbcukmet|weather|Berlin, Germany, DE|2950159";
            };
          };
        }
        {
          name = "org.kde.plasma.marginsseparator";
        }
        {
          name = "org.kde.plasma.kickoff";
          config = {
            General = {
              icon = "application-menu-symbolic";
            };
          };
        }
        {
          name = "org.kde.plasma.digitalclock";
          config = {
            Appearance = {
              autoFontAndSize = false;
              dateDisplayFormat = "BesideTime";
              dateFormat = "longDate";
              fontFamily = config.fontconfig.sans;
              fontSize = 12;
              fontStyleName = "Medium";
              fontWeight = 500;
              selectedTimeZones = "Local,America/New_York,America/Los_Angeles";
              showWeekNumbers = true;
            };
          };
        }
        {
          name = "org.kde.plasma.marginsseparator";
        }
      ];
    }
  ];
}
