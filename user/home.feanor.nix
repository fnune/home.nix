{...}: {
  machine.scale = 2.0;

  # OK for desktop since I won't be using multiple monitors
  systemd.user.sessionVariables.PLASMA_USE_QT_SCALING = 1;
}
