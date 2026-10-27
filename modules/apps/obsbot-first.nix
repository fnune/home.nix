{ lib, pkgs, ... }:
let
  obsbotFirst = pkgs.writeShellApplication {
    name = "obsbot-first";
    runtimeInputs = [
      pkgs.jq
      pkgs.pipewire
    ];
    text = ''
      cameras() {
        pw-dump | jq -c '[.[] | .info.props? // empty | select(.["media.class"] == "Video/Source")]'
      }
      builtin_camera() {
        jq -c 'first(.[] | select(.["device.vendor.id"] == "0x2b7e" and .["device.product.id"] == "0xc858")) // empty' <<<"$1"
      }
      obsbot() {
        jq -c 'first(.[] | select(.["node.nick"] // "" | startswith("OBSBOT"))) // empty' <<<"$1"
      }
      serial() { jq '.["object.serial"]' <<<"$1"; }

      for _ in $(seq 50); do
        listed=$(cameras)
        builtin=$(builtin_camera "$listed")
        external=$(obsbot "$listed")
        [[ -n $builtin && -n $external ]] && break
        sleep 0.2
      done
      [[ -n $builtin && -n $external ]] || exit 0
      (($(serial "$external") < $(serial "$builtin"))) && exit 0

      # Firefox lists cameras in PipeWire registration order, so the built-in one has to register again.
      usb_device=$(readlink -f "/sys/class/video4linux/$(basename "$(jq -r '.["api.v4l2.path"]' <<<"$builtin")")/device/..")
      authorized=$usb_device/authorized
      echo 0 >"$authorized"
      echo 1 >"$authorized"
    '';
  };
in
{
  systemd.user.services.obsbot-first = {
    Unit = {
      Description = "List the OBSBOT camera before the built-in one";
      After = [ "wireplumber.service" ];
    };
    Service = {
      Type = "oneshot";
      ExecStart = lib.getExe obsbotFirst;
    };
    Install.WantedBy = [ "wireplumber.service" ];
  };
}
