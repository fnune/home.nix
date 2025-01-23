{pkgs, ...}: let
  inherit (pkgs) maestral;
in {
  home.packages = [maestral];

  systemd.user.services.maestral = {
    Unit.Description = "Maestral daemon";
    Service = {
      Type = "notify";
      NotifyAccess = "exec";
      ExecStart = "${maestral}/bin/maestral start -f";
      ExecStop = "${maestral}/bin/maestral stop";
      ExecStopPost = ''
        /usr/bin/env bash -c "if [ $${SERVICE_RESULT} != success ]; \
        then notify-send Maestral 'Daemon failed'; fi"
      '';
      WatchdogSec = "30s";
    };
    Install.WantedBy = ["default.target"];
  };
}
