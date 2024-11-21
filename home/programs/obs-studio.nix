{pkgs, ...}: {
  home = {
    packages = [pkgs.obs-studio];
    file.".local/share/applications/com.obsproject.Studio.desktop".text = ''
      [Desktop Entry]
      Version=1.0
      Name=OBS Studio
      GenericName=Streaming/Recording Software
      Comment=Free and Open Source Streaming/Recording Software
      Exec=env QT_QPA_PLATFORM=xcb obs
      Icon=com.obsproject.Studio
      Terminal=false
      Type=Application
      Categories=AudioVideo;Recorder;
      StartupNotify=true
      StartupWMClass=obs
    '';
  };
}
