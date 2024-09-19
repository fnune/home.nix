# `home.nix`

Available machines: `feanor`, `melian` (`hostname` must match).

```bash
nix-shell -p git curl

git clone git@github.com:fnune/home.nix.git ~/.home.nix

sudo nixos-rebuild switch --flake ".#$(hostname)"

nix run . -- build --impure --flake ".fausto#$(hostname)"
nix run . -- switch --impure --flake ".fausto#$(hostname)"
```

After that, you can start using these instead:

```bash
sudo nixos-rebuild switch --flake ".#$(hostname)"

home-manager build --impure --flake ".fausto#$(hostname)"
home-manager switch --impure --flake ".fausto#$(hostname)"
```

Alternatively, you can use [`nh`](https://github.com/viperML/nh):

```bash
nh os switch
nh home switch -- --impure
```

The flag `--impure` is needed for [`nix-ld`](https://github.com/Mic92/nix-ld).
