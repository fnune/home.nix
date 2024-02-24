# `home.nix`

Available machines: `feanor`, `melian`.

```bash
nix-shell -p git curl

git clone git@github.com:fnune/home.nix.git ~/.home.nix

sudo nixos-rebuild switch --flake .#feanor

nix run . -- build --impure --flake .#feanor
nix run . -- switch --impure --flake .#feanor
```

After that, you can start using these instead:

```bash
sudo nixos-rebuild switch --flake .#feanor

home-manager build --impure --flake .#feanor
home-manager switch --impure --flake .#feanor
```

The flag `--impure` is needed for [`nix-ld`](https://github.com/Mic92/nix-ld).
