_: {
  services.apt.packages = [
    "thunderbird"
  ];

  services.flatpak = {
    enable = true;
    packages = [
      "com.dropbox.Client"
      "com.obsproject.Studio"
      "com.obsproject.Studio.Plugin.AdvancedMasks"
      "com.obsproject.Studio.Plugin.BackgroundRemoval"
      "com.slack.Slack"
      "com.spotify.Client"
      "com.yubico.yubioath"
      "io.podman_desktop.PodmanDesktop"
      "md.obsidian.Obsidian"
      "org.darktable.Darktable"
      "org.kde.krita"
      "org.signal.Signal"
      "us.zoom.Zoom"
    ];
  };
}
