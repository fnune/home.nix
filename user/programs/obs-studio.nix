{pkgs, ...}: {
  home.packages = [pkgs.obs-studio];
  xdg.desktopEntries = {
    "com.obsproject.Studio" = {
      name = "OBS Studio";
      exec = "QT_QPA_PLATFORM=xcb obs";

      categories = ["AudioVideo" "Recorder"];
      comment = "Free and Open Source Streaming/Recording Software";
      genericName = "Streaming/Recording Software";
      icon = "com.obsproject.Studio";
      startupNotify = true;
      terminal = false;
      type = "Application";
    };
  };
}
