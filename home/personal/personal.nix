{
  config,
  pkgs,
  pkgs-unstable,
  nixvimPackage,
  ...
}: let
  cloudStorageDir = "${config.home.homeDirectory}/pCloudDrive";
  notesDir = "${cloudStorageDir}/Documents/Notes";
  dotfilesDir = "${config.home.homeDirectory}/.home.nix";

  herdr = import ../programs/herdr/lib.nix {
    inherit pkgs pkgs-unstable;
    shell = config.shell.bin;
  };

  editor = "${nixvimPackage}/bin/nvim";

  personal = herdr.mkProvisioner {
    name = "n";
    focus = "📝 personal";
    workspaces = [
      {
        label = "📝 personal";
        focusTab = "dotfiles";
        tabs = [
          {
            label = "dotfiles";
            root = herdr.split {
              direction = "right";
              first = herdr.pane {
                cwd = dotfilesDir;
                command = ["repo-ui"];
              };
              second = herdr.split {
                direction = "down";
                first = herdr.pane {
                  cwd = dotfilesDir;
                  command = [editor];
                };
                second = herdr.pane {cwd = dotfilesDir;};
              };
            };
          }
          {
            label = "notes";
            root = herdr.pane {
              cwd = notesDir;
              command = [editor "-c" "NvimTreeToggle"];
            };
          }
        ];
      }
    ];
  };
in {
  home = {
    packages = [personal];

    file = {
      "${config.home.homeDirectory}/.zsh/includes/n-tmux".source = ./launch.sh;
    };
    sessionVariables = {
      CLOUD_STORAGE_DIR = cloudStorageDir;
      NOTES_DIR = notesDir;
    };
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
