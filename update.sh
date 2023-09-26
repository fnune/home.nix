#!/usr/bin/env bash

# https://nix-community.github.io/home-manager/index.html#sec-updating
nix-channel --update
echo "Now, run 'home-manager --switch'."
