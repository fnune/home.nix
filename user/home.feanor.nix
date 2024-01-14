{...}: {
  machine.scale = 2.0;

  dconf.settings = {
    "org/gnome/desktop/interface" = {
      "text-scaling-factor" = 0.95;
    };
  };
}
