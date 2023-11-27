{pkgs}: rec {
  description = "Vanta monitoring software";
  wantedBy = ["multi-user.target"];
  serviceConfig = {
    ExecStartPre = ''
      ${pkgs.coreutils}/bin/cp -r ${package}/var/vanta/ /var/vanta/
    '';
    ExecStart = "/var/vanta/metalauncher";
    KillMode = "control-group";
    KillSignal = "SIGTERM";
    Restart = "on-failure";
    TimeoutStartSec = 0;
  };

  package = pkgs.stdenv.mkDerivation rec {
    pname = "vanta";
    version = "2.4.0";

    src = pkgs.fetchurl {
      url = "https://vanta-agent-repo.s3.amazonaws.com/targets/versions/${version}/vanta-amd64.deb";
      sha256 = "59ac810c737d0290978a0092132f1c51571da52a8cf5413f31c1c317758be13d";
    };

    nativeBuildInputs = with pkgs; [dpkg autoPatchelfHook];
    buildInputs = [pkgs.stdenv.cc.cc.lib];

    unpackPhase = ''
      dpkg-deb -x $src .
    '';

    # To complete the installation:
    #   export VANTA_KEY [...]' # from https://app.vanta.com/employee/onboarding
    #   VANTA_CONF_PATH="/etc/vanta.conf"
    #   echo "$CONFIG" | sudo -E tee "$VANTA_CONF_PATH" > /dev/null
    #   sudo chmod 400 "$VANTA_CONF_PATH"
    #   sudo chown root:wheel "$VANTA_CONF_PATH"
    installPhase = ''
      mkdir -p $out
      cp -r ./* $out
    '';

    meta = with pkgs.lib; {
      description = "Vanta Agent";
      homepage = "https://www.vanta.com";
      license = licenses.unfree;
      platforms = platforms.linux;
    };
  };
}
