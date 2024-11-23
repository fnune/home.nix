{
  lib,
  pkgs,
  ...
}: let
  v4l2Ctl = "${pkgs.v4l-utils}/bin/v4l2-ctl";
  script = pkgs.writeShellScriptBin "c920-camera-setup" ''
    #!/bin/sh
    set -euo pipefail
    echo "Starting C920 camera setup..."
    DEVICE=$(${v4l2Ctl} --list-devices | grep -A1 C920 | tail -n1 | xargs)
    if [ -n "$DEVICE" ]; then
      echo "Configuring C920 camera settings..."
      ${v4l2Ctl} -d $DEVICE --set-ctrl=focus_automatic_continuous=0 2> /dev/null || v4l2-ctl -d $DEVICE --set-ctrl=focus_auto=0
      ${v4l2Ctl} -d $DEVICE --set-ctrl=gain=190
      ${v4l2Ctl} -d $DEVICE --set-ctrl=zoom_absolute=125
      ${v4l2Ctl} -d $DEVICE --set-ctrl=focus_absolute=130
      ${v4l2Ctl} -d $DEVICE --set-ctrl=pan_absolute=1400
      ${v4l2Ctl} -d $DEVICE --set-ctrl=white_balance_automatic=1 2> /dev/null || v4l2-ctl -d $DEVICE --set-ctrl=white_balance_temperature_auto=1
      ${v4l2Ctl} -d $DEVICE --set-ctrl=sharpness=160
      ${v4l2Ctl} -d $DEVICE --set-ctrl=auto_exposure=3 2> /dev/null || v4l2-ctl -d $DEVICE --set-ctrl=exposure_auto=3
      echo "C920 camera setup completed."
    else
      echo "No C920 camera found."
    fi
  '';
in {
  home.packages = [pkgs.v4l-utils script];

  xdg.configFile."autostart/c920-camera-setup.desktop".text = lib.mkAfter ''
    [Desktop Entry]
    Type=Application
    Exec=${script}/bin/c920-camera-setup
    Hidden=false
    NoDisplay=true
    Name=C920 Camera Setup
  '';
}
