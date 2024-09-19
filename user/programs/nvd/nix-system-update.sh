#!/usr/bin/env bash
set -euo pipefail

homeDir="$HOME/.home.nix"
hostname="$(hostname)"

pushd "$homeDir"
trap 'popd' EXIT

old_lock_hash="$(sha256sum flake.lock | awk '{print $1}')"

echo "🔄 Running 'nix flake update'..."
nix flake update

new_lock_hash="$(sha256sum flake.lock | awk '{print $1}')"

if [ "$old_lock_hash" = "$new_lock_hash" ]; then
  echo "✅ No updates were made to the flake. Exiting."
  exit 0
else
  echo "🆕 Flake updated! Proceeding with system rebuild..."
fi

echo "⚙️ Rebuilding system using 'nixos-rebuild'..."
sudo nixos-rebuild switch --flake ".#${hostname}" && nvd-system-diff

echo "⚙️ Switching home-manager configuration..."
home-manager switch --impure --flake ".#${hostname}" && nvd-profile-diff

echo "🎉 All done!"
