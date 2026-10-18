{ gpuDrivers, lib, ... }:
let
  inotify = ''
    fs.inotify.max_user_instances = 1024
    fs.inotify.max_user_watches = 524288
  '';

  journald = ''
    [Journal]
    SystemMaxUse=2G
    MaxRetentionSec=3month
  '';
in
{
  imports = [
    ./chrome.nix
    ./locales.nix
  ];

  nix = {
    enable = true;
    settings = {
      build-users-group = "nixbld"; # Otherwise the daemon builds as root.
      warn-dirty = false;
      # system-manager passes its cache on every build.
      trusted-substituters = [ "https://cache.numtide.com" ];
      trusted-public-keys = [ "niks3.numtide.com-1:DTx8wZduET09hRmMtKdQDxNNthLQETkc/yaX7M4qK0g=" ];
    };
  };

  systemd.tmpfiles.rules = [ "L+ /run/opengl-driver - - - - ${gpuDrivers}" ];

  environment.etc =
    lib.mapAttrs
      (_: text: {
        inherit text;
        replaceExisting = true;
      })
      {
        "sysctl.d/99-inotify.conf" = inotify;
        "systemd/journald.conf.d/99-retention.conf" = journald;
        "containers/nodocker" = ""; # Silences podman's Docker emulation notice.
      };

  systemd.services.apply-system-drop-ins = {
    description = "Apply sysctl and journald drop-ins";
    wantedBy = [ "system-manager.target" ];
    restartTriggers = [
      inotify
      journald
    ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };
    script = ''
      /usr/bin/systemctl restart systemd-sysctl systemd-journald
    '';
  };
}
