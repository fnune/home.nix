# `home.nix`

Bootstrap on Debian:

```bash
bash <(curl --proto '=https' --tlsv1.2 -L https://raw.githubusercontent.com/fnune/home.nix/refs/heads/debian/scripts/debian.sh)
```

To upgrade:

```bash
nix flake update
home-manager switch --flake "."
```
