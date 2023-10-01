# `home.nix`

```
sudo apt install build-essential curl wget git kitty

git clone git@github.com:fnune/home.nix.git ~/.home.nix

mkdir -p ~/.config/nix/
echo "experimental-features = nix-command flakes" > ~/.config/nix/nix.conf

nix run . -- build --flake .
nix run . -- switch --flake .
```
