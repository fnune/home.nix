{config, ...}: {
  systemd.user.sessionVariables = {
    PATH = "${config.home.profileDirectory}/bin:$PATH";
    XDG_DATA_DIRS = "${config.home.profileDirectory}/share:$XDG_DATA_DIRS";
  };
}
