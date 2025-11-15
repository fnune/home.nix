{
  config,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [pcloud];

  services.pacman.packages = [
    "bitwarden"
    "bitwarden-cli"
    "darktable"
    "krita"
    "obs-studio"
    "obsidian"
    "podman-desktop"
    "signal-desktop"
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
