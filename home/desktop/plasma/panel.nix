{config, ...}: {
  programs.plasma.panels = [
    {
      inherit (config.panel) height;
      hiding = "normalpanel";
      lengthMode = "fill";
      location = "top";
      opacity = "adaptive";
      screen = null;
      widgets = [
        {
          name = "org.kde.plasma.marginsseparator";
        }
        {
          name = "org.kde.plasma.pager";
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
          name = "org.kde.plasma.marginsseparator";
        }
        {
          name = "org.kde.plasma.systemmonitor.cpu";
          config = {
            Appearance = {
              chartFace = "org.kde.ksysguard.linechart";
            };
            SensorColors = {
              "cpu/all/usage" = config.accent.rgb;
            };
          };
        }
        {
          name = "org.kde.plasma.systemmonitor.memory";
          config = {
            Appearance = {
              chartFace = "org.kde.ksysguard.linechart";
            };
            SensorColors = {
              "memory/physical/used" = config.accent.rgb;
            };
          };
        }
        {
          name = "org.kde.plasma.systemtray";
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
              autoFontAndSize = true;
              dateDisplayFormat = "BelowTime";
              dateFormat = "custom";
              customDateFormat = "dddd, d MMMM";
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
