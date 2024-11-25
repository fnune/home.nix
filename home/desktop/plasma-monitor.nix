{pkgs, ...}: {
  systemd.user.services."plasma-config-monitor" = {
    Unit.Description = "Monitor Plasma configuration changes";
    Install.WantedBy = ["default.target"];
    Service = {
      ExecStart = "${pkgs.writeShellScript "plasma-monitor" (builtins.readFile ./plasma-monitor.sh)}";
      Restart = "always";
      RestartSec = "5s";
    };
  };
}
