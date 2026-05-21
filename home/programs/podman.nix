{pkgs, ...}: {
  home.packages = with pkgs; [
    podman
    podman-compose
  ];

  home.file = {
    ".local/bin/docker" = {
      executable = true;
      text = ''
        #!/bin/sh
        exec podman "$@"
      '';
    };
    ".local/bin/docker-compose" = {
      executable = true;
      text = ''
        #!/bin/sh
        exec podman-compose "$@"
      '';
    };
  };

  xdg.configFile."containers/registries.conf".text = ''
    unqualified-search-registries = ["docker.io"]
    short-name-mode = "permissive"
  '';
}
