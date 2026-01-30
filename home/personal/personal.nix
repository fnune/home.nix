{config, ...}: let
  cloudStorageDir = "${config.home.homeDirectory}/pCloudDrive";
  notesDir = "${cloudStorageDir}/Documents/Notes";
in {
  home = {
    file = {
      "${config.home.homeDirectory}/.zsh/includes/n".source = ./launch.sh;
    };
    sessionVariables = {
      CLOUD_STORAGE_DIR = cloudStorageDir;
      NOTES_DIR = notesDir;
    };
  };
}
