_:
let
  sshdHardening = ''
    PasswordAuthentication no
    KbdInteractiveAuthentication no
    PermitRootLogin no
  '';
in
{
  imports = [ ./base.nix ];

  nix.settings.trusted-users = [ "fausto" ]; # For nix copy of unsigned closures, see docs/earendil.md.

  environment.etc."ssh/sshd_config.d/10-hardening.conf" = {
    text = sshdHardening;
    replaceExisting = true;
  };

  systemd.services.sshd-reload = {
    description = "Reload sshd after its drop-ins change";
    wantedBy = [ "system-manager.target" ];
    restartTriggers = [ sshdHardening ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };
    script = ''
      /usr/bin/systemctl try-reload-or-restart sshd
    '';
  };
}
