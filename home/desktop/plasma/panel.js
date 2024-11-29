/**
 * Inspect ~/.config/plasma-org.kde.plasma.desktop-appletsrc
 * to find the live configuration data used by Plasma.
 */
function configure(type, groups) {
  for (const panel of panels()) {
    for (const widget of panel.widgets()) {
      if (widget.type === type) {
        for (const [group, options] of Object.entries(groups)) {
          widget.currentConfigGroup = [group];
          for (const [key, value] of Object.entries(options)) {
            widget.writeConfig(key, value);
          }
        }
      }
    }
  }
}

configure("org.kde.plasma.pager", {
  General: {
    displayedText: "Number",
  },
});

configure("org.kde.plasma.icontasks", {
  General: {
    launchers: "",
    minimizeActiveTaskOnClick: false,
    showOnlyCurrentActivity: false,
    showOnlyCurrentDesktop: false,
    wheelEnabled: false,
  },
});

configure("org.kde.plasma.kickoff", {
  General: {
    icon: "application-menu-symbolic",
  },
});

configure("org.kde.plasma.weather", {
  WeatherStation: {
    source: "bbcukmet|weather|Berlin, Germany, DE|2950159",
  },
});

configure("org.kde.plasma.digitalclock", {
  Appearance: {
    dateFormat: "longDate",
    selectedTimeZones: "Local,America/New_York,America/Los_Angeles",
    showWeekNumbers: true,
  },
});
