{pkgs, ...}: {
  services.podman.enable = true;
  services.podman.settings.containers.containers.hostadd = ["host.docker.internal:host-gateway"];

  home.packages = [pkgs.podman-compose];

  home.sessionVariables = {
    DOCKER_HOST = "unix://\${XDG_RUNTIME_DIR}/podman/podman.sock";
  };

  systemd.user.sockets.podman = {
    Unit.Description = "Podman API socket";
    Socket = {
      ListenStream = "%t/podman/podman.sock";
      SocketMode = "0660";
    };
    Install.WantedBy = ["sockets.target"];
  };

  systemd.user.services.podman = {
    Unit = {
      Description = "Podman API service";
      Requires = ["podman.socket"];
      After = ["podman.socket"];
    };
    Service = {
      Type = "exec";
      KillMode = "process";
      Environment = "LOGGING=--log-level=info";
      ExecStart = "${pkgs.podman}/bin/podman $LOGGING system service";
    };
  };

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
