_:
let
  openclOnRadeon.RUSTICL_ENABLE = "radeonsi";
in
{
  home.sessionVariables = openclOnRadeon;
  systemd.user.sessionVariables = openclOnRadeon;
}
