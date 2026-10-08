{
  config,
  lib,
  pkgs,
  ...
}:
let
  connectionName = "bilbo";
  endpoint = "wireguard.fnune.com:51820";
  bilboPublicKey = "aVdLGe76+qHh25zQBy3zfb3qp35IeZU4DWZvrowUX0g=";
  subnet = "10.100.0.0/24";
  addressByHost = {
    melian = "10.100.0.3";
    feanor = "10.100.0.4";
  };

  keyDir = "${config.xdg.configHome}/wireguard";
  privateKeyFile = "${keyDir}/${connectionName}.key";
  publicKeyFile = "${keyDir}/${connectionName}.pub";
  importedHashFile = "${keyDir}/${connectionName}.imported";

  systemNmcli = "/usr/bin/nmcli";
  wg = lib.getExe' pkgs.wireguard-tools "wg";
  uname = lib.getExe' pkgs.coreutils "uname";
  sha256sum = lib.getExe' pkgs.coreutils "sha256sum";

  addressCases = lib.concatStringsSep "\n" (
    lib.mapAttrsToList (host: address: "        ${host}) address=${address} ;;") addressByHost
  );
in
{
  home.activation.wireguardToBilbo = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        if [[ ! -v DRY_RUN ]]; then
          address=
          case "$(${uname} -n)" in
    ${addressCases}
          esac
          if [ -z "$address" ]; then
            $VERBOSE_ECHO "wireguard: no tunnel address for this host, leaving ${connectionName} alone"
          else
            umask 077
            mkdir -p ${keyDir}
            [ -f ${privateKeyFile} ] || ${wg} genkey > ${privateKeyFile}
            ${wg} pubkey < ${privateKeyFile} > ${publicKeyFile}

            confDir=$(mktemp -d -p "''${XDG_RUNTIME_DIR:-/tmp}")
            conf="$confDir/${connectionName}.conf"
            {
              echo "[Interface]"
              echo "PrivateKey = $(cat ${privateKeyFile})"
              echo "Address = $address/32"
              echo
              echo "[Peer]"
              echo "PublicKey = ${bilboPublicKey}"
              echo "Endpoint = ${endpoint}"
              echo "AllowedIPs = ${subnet}"
              echo "PersistentKeepalive = 25"
            } > "$conf"

        hash=$(${sha256sum} "$conf" | cut -d" " -f1)
            if [ "$(cat ${importedHashFile} 2>/dev/null)" != "$hash" ]; then
              ${systemNmcli} connection delete ${connectionName} >/dev/null 2>&1 || true
              ${systemNmcli} connection import type wireguard file "$conf"
              ${systemNmcli} connection modify ${connectionName} connection.autoconnect yes ipv6.method disabled
              echo "$hash" > ${importedHashFile}
            fi
            rm -rf "$confDir"

            echo "wireguard: this machine's public key for bilbo's devices is $(cat ${publicKeyFile})"
          fi
        fi
  '';
}
