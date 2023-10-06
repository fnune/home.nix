#!/usr/bin/env bash

set -euo pipefail

MACHINE_PATTERN="feanor|melian" # Fëanor (desktop), Melian (work laptop)
MACHINE=${1-}

abort () {
  echo >&2 "🛑 Aborting: $*"
  exit 1
}

[ "$#" -eq 1 ] || abort "need one argument MACHINE ($MACHINE_PATTERN), got $#."
echo "$1" | grep -E -q "^($MACHINE_PATTERN)$" || abort "value of argument MACHINE must be one of $MACHINE_PATTERN."

ETC_NIXOS_BAK=/etc/nixos.bak.$(uuidgen)
echo "📂 Backing up /etc/nixos to $ETC_NIXOS_BAK"
sudo mkdir --parents "$ETC_NIXOS_BAK"

if [ -f "/etc/nixos/configuration.nix" ]; then
  echo "📋 Copying configuration.nix to backup"
  sudo cp /etc/nixos/configuration.nix "$ETC_NIXOS_BAK"
fi

if [ -f "/etc/nixos/hardware-configuration.nix" ]; then
  echo "📋 Copying hardware-configuration.nix to backup"
  sudo cp /etc/nixos/hardware-configuration.nix "$ETC_NIXOS_BAK"
fi

echo "🗑️  Removing existing /etc/nixos/configuration.nix"
sudo rm /etc/nixos/configuration.nix

echo "🔗 Creating symbolic link for new configuration"
sudo ln --symbolic "$(readlink -f ./system/machine/"$MACHINE"/configuration.nix)" /etc/nixos/configuration.nix

echo "✅ Done"
