{
  config,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [pcloud];

  services.syncthing.enable = true;

  services.pacman.packages = [
    "bitwarden"
    "bitwarden-cli"
    "darktable"
    "krita"
    "obsidian"
    "podman-desktop"
    "signal-desktop"
    "solaar"
    "steam"
    "thunderbird"
  ];

  services.flatpak = {
    enable = true;
    packages = [
      "com.slack.Slack"
      "com.spotify.Client"
      "us.zoom.Zoom"
    ];
  };

  xdg.autostart = let
    flatpakApps = "${config.home.homeDirectory}/.local/share/flatpak/exports/share/applications";
  in {
    enable = true;
    entries = [
      "${flatpakApps}/com.dropbox.Client.desktop"
    ];
  };
}
