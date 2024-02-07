#!/usr/bin/env bash

N=${1:-1}

mapfile -t profiles < <(find /nix/var/nix/profiles -name 'system-*-link' -print0 | sort -zV | xargs -0 -n 1 echo | tail -n "$((N + 1))")

older=${profiles[0]}
newer=${profiles[-1]}
nvd diff "$older" "$newer"
