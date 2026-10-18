{ clack, pkgs, ... }:
let
  rules = "${
    clack.packages.${pkgs.stdenv.hostPlatform.system}.default
  }/lib/udev/rules.d/65-clack.rules";
in
{
  environment.etc."udev/rules.d/65-clack.rules" = {
    source = rules;
    replaceExisting = true;
  };

  systemd.services.clack-udev-trigger = {
    description = "Apply Clack's udev rule to connected keyboards";
    wantedBy = [ "system-manager.target" ];
    restartTriggers = [ rules ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };
    script = ''
      /usr/bin/udevadm control --reload
      /usr/bin/udevadm trigger --subsystem-match=input --action=change
    '';
  };
}
