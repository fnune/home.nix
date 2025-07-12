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
    version = "2.14.0";

    src = pkgs.fetchurl {
      url = "https://agent-downloads.vanta.com/targets/versions/${version}/vanta-amd64.deb";
      sha256 = "sha256-IYRaXpR3z7Yfd5qcHZryya2UzX9rldjdB27/uTXufUk";
    };

    nativeBuildInputs = with pkgs; [dpkg autoPatchelfHook];
    buildInputs = [pkgs.stdenv.cc.cc.lib];

    unpackPhase = ''
      dpkg-deb -x $src .
    '';

    # To complete the installation, copy VANTA_{KEY,OWNER_EMAIL} from https://app.vanta.com/employee/onboarding
    #
    # export VANTA_KEY="..."
    # export VANTA_OWNER_EMAIL="..."
    # export VANTA_REGION="..."
    # export VANTA_CONF_PATH="/etc/vanta.conf"
    # export CONFIG="{\"AGENT_KEY\":\"$VANTA_KEY\",\"OWNER_EMAIL\":\"$VANTA_OWNER_EMAIL\",\"NEEDS_OWNER\":true}"
    #
    # echo "$CONFIG" | sudo -E tee "$VANTA_CONF_PATH" > /dev/null
    #
    # sudo chmod 400 "$VANTA_CONF_PATH"
    # sudo chown root:root "$VANTA_CONF_PATH"
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
