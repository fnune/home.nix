{pkgs, ...}: {
  environment.systemPackages = [pkgs.v4l-utils];
  systemd.services.c920-camera-setup = {
    enable = true;
    description = "C920 camera setup service";
    after = ["graphical-session-pre.target"];
    wants = ["graphical-session-pre.target"];
    partOf = ["graphical-session.target"];
    wantedBy = ["graphical.target"];
    serviceConfig = {
      ExecStart = let
        sleepUntilReadySeconds = "10";
        v4l2Ctl = "${pkgs.v4l-utils}/bin/v4l2-ctl";
        script = pkgs.writeShellScript "inline" ''
          #!/bin/sh
          echo "Starting C920 camera setup in ${sleepUntilReadySeconds}s..."
          sleep ${sleepUntilReadySeconds}
          DEVICE=$(${v4l2Ctl} --list-devices | grep -A1 C920 | tail -n1 | xargs)
          if [ $DEVICE ]; then
            echo "Configuring C920 camera settings..."
            ${v4l2Ctl} -d $DEVICE --set-ctrl=auto_exposure=3
            ${v4l2Ctl} -d $DEVICE --set-ctrl=focus_absolute=130
            ${v4l2Ctl} -d $DEVICE --set-ctrl=focus_automatic_continuous=0
            ${v4l2Ctl} -d $DEVICE --set-ctrl=gain=190
            ${v4l2Ctl} -d $DEVICE --set-ctrl=pan_absolute=1400
            ${v4l2Ctl} -d $DEVICE --set-ctrl=sharpness=160
            ${v4l2Ctl} -d $DEVICE --set-ctrl=white_balance_automatic=1
            ${v4l2Ctl} -d $DEVICE --set-ctrl=zoom_absolute=125
            echo "C920 camera setup completed."
          else
            echo "No C920 camera found."
          fi
        '';
      in "${script}";
      StandardOutput = "journal";
      StandardError = "journal";
      User = "root";
      Group = "root";
    };
  };
}
