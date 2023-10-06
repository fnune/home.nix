# `home.nix`

Available machines: `feanor`, `melian`.

```bash
nix-shell -p git curl

git clone git@github.com:fnune/home.nix.git ~/.home.nix

sudo nixos-rebuild switch --flake .#feanor

nix run . -- build --flake .#feanor
nix run . -- switch --flake .#feanor
```
