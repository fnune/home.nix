_: {
  services.flatpak = {
    enable = true;
    packages = [
      "com.dropbox.Client"
      "com.jetbrains.DataGrip"
      "com.jetbrains.GoLand"
      "com.obsproject.Studio"
      "com.slack.Slack"
      "com.spotify.Client"
      "com.yubico.yubioath"
      "org.darktable.Darktable"
      "org.kde.krita"
      "org.signal.Signal"
      "us.zoom.Zoom"
    ];
  };
}
