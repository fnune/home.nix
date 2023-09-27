# `home.nix`

```
git clone git@github.com:fnune/home.nix.git ~/.home.nix

nix run . -- build --flake .
nix run . -- switch --flake .

echo "Reload the shell and run 'home-manager switch --flake .'."
```
