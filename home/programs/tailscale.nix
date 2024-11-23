{pkgs, ...}: {
  home.packages = with pkgs; [tailscale-systray];

  xdg.configFile."autostart/tailscale-systray.desktop".text = ''
    [Desktop Entry]
    Type=Application
    Exec=${pkgs.tailscale-systray}/bin/tailscale-systray
    Hidden=false
    NoDisplay=false
    Name=Tailscale Systray
  '';
}
