_:
let
  protonOnWayland.PROTON_ENABLE_WAYLAND = "1";
in
{
  home.sessionVariables = protonOnWayland;
  systemd.user.sessionVariables = protonOnWayland;
}
