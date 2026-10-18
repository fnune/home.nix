{ pkgs-unstable, ... }:
{
  services.syncthing.enable = true;

  home.packages = with pkgs-unstable; [
    bitwarden-cli
    bitwarden-desktop
    calibre
    darktable
    krita
    obsidian
    podman-desktop
    signal-desktop
  ];

  services.pacman.packages = [
    "keepsecret"
    "solaar"
    "steam"
  ];

  services.flatpak = {
    enable = true;
    update.auto = {
      enable = true;
      onCalendar = "daily";
    };
    packages = [
      "com.slack.Slack"
      "com.spotify.Client"
      "us.zoom.Zoom"
    ];
  };
}
