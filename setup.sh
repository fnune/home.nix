#!/usr/bin/env bash

# https://nix-community.github.io/home-manager/index.html#sec-install-standalone
nix-channel --add https://github.com/nix-community/home-manager/archive/release-23.05.tar.gz home-manager
nix-channel --update
nix-shell '<home-manager>' -A install

touch "$HOME/.profile"
source_session_vars='. "$HOME/.nix-profile/etc/profile.d/hm-session-vars.sh"'

if ! grep -q "$source_session_vars" "$HOME/.profile"; then
  echo -e "\n$source_session_vars" >> "$HOME/.profile"
fi

# Link up home.nix
mkdir -p "$HOME/.config/home-manager/"
cp $(readlink -f "$HOME/.config/home-manager/home.nix") "$HOME/.config/home-manager/home-$(date --iso).nix.bak"
rm "$HOME/.config/home-manager/home.nix"
script_directory=$(dirname $(readlink -f "$0"))
ln -s "$script_directory/home.nix" "$HOME/.config/home-manager/home.nix"
