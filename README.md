# `home.nix`

```
git clone git@github.com:fnune/home.nix.git ~/.home.nix

nix --extra-experimental-features nix-command --extra-experimental-features flakes run . -- build --flake .
nix --extra-experimental-features nix-command --extra-experimental-features flakes run . -- switch --flake .

echo "Reload the shell and run 'home-manager switch --flake .'."
```
