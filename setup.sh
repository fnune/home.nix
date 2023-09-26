#!/usr/bin/env bash

repo=$(dirname $(readlink -f "$0"))

# Link up home.nix
mkdir -p "$HOME/.config/home-manager/"
rm -f "$HOME/.config/home-manager/home.nix"
ln -s "$repo/home.nix" "$HOME/.config/home-manager/home.nix"

# Set up nix.conf
mkdir -p "$HOME/.config/nix/"
rm -f "$HOME/.config/nix/nix.conf"
ln -s "$repo/nix.conf" "$HOME/.config/nix/nix.conf"
