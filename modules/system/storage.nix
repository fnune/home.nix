{config, ...}: let
  cloudStorageDir = "${config.home.homeDirectory}/pCloudDrive";
  notesDir = "${cloudStorageDir}/Documents/Notes";
in {
  home.sessionVariables = {
    CLOUD_STORAGE_DIR = cloudStorageDir;
    NOTES_DIR = notesDir;
  };

  programs.rclone = {
    enable = true;
    remotes.pcloud = {
      config = {
        type = "pcloud";
        hostname = "eapi.pcloud.com";
      };
      secrets.token = "${config.xdg.configHome}/rclone/pcloud.token";
      mounts."/" = {
        enable = true;
        mountPoint = cloudStorageDir;
      };
    };
  };
}
