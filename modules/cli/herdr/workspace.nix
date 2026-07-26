{
  config,
  nixvimPackage,
  herdr,
  ...
}: let
  cloudStorageDir = "${config.home.homeDirectory}/pCloudDrive";
  notesDir = "${cloudStorageDir}/Documents/Notes";
  dotfilesDir = "${config.home.homeDirectory}/.home.nix";
  blogDir = "${config.home.homeDirectory}/Development/fnune.github.io";

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
      {
        label = "✍️ blog";
        focusTab = "blog";
        tabs = [
          {
            label = "blog";
            root = herdr.split {
              direction = "right";
              first = herdr.pane {
                cwd = blogDir;
                command = ["repo-ui"];
              };
              second = herdr.split {
                direction = "down";
                first = herdr.pane {
                  cwd = blogDir;
                  command = [editor];
                };
                second = herdr.pane {cwd = blogDir;};
              };
            };
          }
        ];
      }
    ];
  };
in {
  home.packages = [personal];
}
