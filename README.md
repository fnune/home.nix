# `home.nix`

```bash
nix-shell -p git curl

git clone git@github.com:fnune/home.nix.git ~/.home.nix

./bootstrap.sh feanor # or
./bootstrap.sh melian

sudo nixos-rebuild switch

nix run . -- build --flake ".#$HOSTNAME"
nix run . -- switch --flake ".#$HOSTNAME"
```
