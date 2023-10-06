{pkgs, ...}: {
  home.packages = [pkgs.v4l_utils];
  systemd.user.services = {
    "c920-camera-setup" = {
      Unit = {
        Description = "C920 camera setup service";
        PartOf = ["graphical-session.target"];
      };
      Install = {
        WantedBy = ["default.target"];
      };
      Service = {
        ExecStart = let
          script = pkgs.writeShellScript "inline" ''
            #!/bin/sh
            echo "Starting C920 camera setup..."
            DEVICE=$(v4l2-ctl --list-devices | grep -A1 C920 | tail -n1 | xargs)
            if [ $DEVICE ]; then
              echo "Configuring C920 camera settings..."
                v4l2-ctl -d $DEVICE --set-ctrl=focus_automatic_continuous=0 2> /dev/null || v4l2-ctl -d $DEVICE --set-ctrl=focus_auto=0
                v4l2-ctl -d $DEVICE --set-ctrl=gain=190
                v4l2-ctl -d $DEVICE --set-ctrl=zoom_absolute=125
                v4l2-ctl -d $DEVICE --set-ctrl=focus_absolute=100
                v4l2-ctl -d $DEVICE --set-ctrl=pan_absolute=1400
                v4l2-ctl -d $DEVICE --set-ctrl=white_balance_automatic=1 2> /dev/null || v4l2-ctl -d $DEVICE --set-ctrl=white_balance_temperature_auto=1
                v4l2-ctl -d $DEVICE --set-ctrl=sharpness=160
                v4l2-ctl -d $DEVICE --set-ctrl=auto_exposure=3 2> /dev/null || v4l2-ctl -d $DEVICE --set-ctrl=exposure_auto=3
              echo "C920 camera setup completed."
            else
              echo "No C920 camera found."
            fi
          '';
        in "${script}";
        StandardOutput = "journal";
        StandardError = "journal";
      };
    };
  };
}
