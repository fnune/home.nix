{ lib, ... }:
let
  locales = lib.unique (builtins.attrValues (import ../modules/system/locales.nix));
  localeGen = lib.concatMapStrings (locale: "${locale} UTF-8\n") locales;
in
{
  environment.etc."locale.gen" = {
    text = localeGen;
    replaceExisting = true;
  };

  systemd.services.locale-gen = {
    description = "Generate the locales in /etc/locale.gen";
    wantedBy = [ "system-manager.target" ];
    restartTriggers = [ localeGen ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };
    script = ''
      PATH=/usr/bin:$PATH /usr/bin/locale-gen # It calls localedef from PATH.
    '';
  };
}
