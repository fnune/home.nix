_: {
  services.apt.packages = [
    "thunderbird"
  ];

  services.flatpak = {
    enable = true;
    packages = [
      "com.dropbox.Client"
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
