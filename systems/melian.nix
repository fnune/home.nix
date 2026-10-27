{ pkgs, ... }:
let
  obsbotFirstRules = ''
    ACTION!="remove", SUBSYSTEM=="usb", ENV{DEVTYPE}=="usb_device", ATTR{idVendor}=="2b7e", ATTR{idProduct}=="c858", RUN+="${pkgs.coreutils}/bin/chgrp video /sys%p/authorized", RUN+="${pkgs.coreutils}/bin/chmod g+w /sys%p/authorized"
    ACTION=="add", SUBSYSTEM=="video4linux", ATTRS{product}=="OBSBOT Meet SE", TAG+="systemd", ENV{SYSTEMD_USER_WANTS}+="obsbot-first.service"
  '';
in
{
  imports = [ ./desktop.nix ];

  environment.etc."wireplumber/wireplumber.conf.d/51-disable-ir-camera.conf" = {
    text = builtins.toJSON {
      "monitor.v4l2.rules" = [
        {
          matches = [ { "api.v4l2.cap.card" = "FHD WebCam: IR Camera"; } ];
          actions.update-props."node.disabled" = true;
        }
      ];
    };
    replaceExisting = true;
  };

  environment.etc."udev/rules.d/70-obsbot-first.rules" = {
    text = obsbotFirstRules;
    replaceExisting = true;
  };

  systemd.services.obsbot-first-udev-trigger = {
    description = "Apply the OBSBOT-first udev rules to connected cameras";
    wantedBy = [ "system-manager.target" ];
    restartTriggers = [ obsbotFirstRules ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };
    script = ''
      /usr/bin/udevadm control --reload
      /usr/bin/udevadm trigger --subsystem-match=usb --property-match=DEVTYPE=usb_device --action=change
    '';
  };

  environment.etc."sdboot-manage.conf.d/99-tuxedo.conf".text = ''
    LINUX_OPTIONS="zswap.enabled=0 quiet splash amdgpu.dcdebugmask=0x10 acpi.ec_no_wakeup=1 amdgpu.ppfeaturemask=0xfff73fff"
  '';
}
