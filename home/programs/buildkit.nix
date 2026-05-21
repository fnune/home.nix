{
  lib,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    buildkit
    rootlesskit
    runc
    slirp4netns
  ];

  home.sessionVariables = {
    BUILDKIT_HOST = "unix://\${XDG_RUNTIME_DIR}/buildkit/buildkitd.sock";
  };

  systemd.user.services.buildkit = {
    Unit = {
      Description = "Rootless BuildKit daemon";
      After = ["default.target"];
    };

    Service = {
      Type = "simple";
      Environment = "PATH=${lib.makeBinPath [pkgs.slirp4netns pkgs.rootlesskit pkgs.buildkit pkgs.runc pkgs.coreutils]}:/usr/bin";
      ExecStart = "${pkgs.rootlesskit}/bin/rootlesskit --net=slirp4netns --copy-up=/etc --copy-up=/run --disable-host-loopback ${pkgs.buildkit}/bin/buildkitd --oci-worker-no-process-sandbox";
      Restart = "on-failure";
      RestartSec = "5s";
    };

    Install.WantedBy = ["default.target"];
  };
}
