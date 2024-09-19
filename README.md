# `home.nix`

Available machines: `feanor`, `melian` (`hostname` must match).

```bash
nix-shell -p git curl

git clone git@github.com:fnune/home.nix.git ~/.home.nix

sudo nixos-rebuild switch --flake ".#$(hostname)"

nix run . -- build --impure --flake ".#$(hostname)"
nix run . -- switch --impure --flake ".#$(hostname)"
```

After that, you can start using these instead:

```bash
sudo nixos-rebuild switch --flake ".#$(hostname)"

home-manager build --impure --flake ".#$(hostname)"
home-manager switch --impure --flake ".#$(hostname)"
```

The flag `--impure` is needed for [`nix-ld`](https://github.com/Mic92/nix-ld).
