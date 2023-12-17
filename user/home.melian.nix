{...}: {
  machine.scale = 1.0;

  dconf.settings = {
    "org/gnome/shell/extensions/appindicator" = {
      "icon-size" = 22;
    };
  };
}
