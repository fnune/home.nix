_: {
  services.flatpak = {
    enable = true;
    packages = [
      "com.slack.Slack"
      "com.spotify.Client"
      "com.yubico.yubioath"
      "org.kde.krita"
      "org.signal.Signal"
      "us.zoom.Zoom"
    ];
  };
}
