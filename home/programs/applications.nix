{pkgs, ...}: {
  home.packages = with pkgs; [pcloud];

  services.syncthing.enable = true;

  services.pacman.packages = [
    "bitwarden"
    "bitwarden-cli"
    "calibre"
    "darktable"
    "foliate"
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
