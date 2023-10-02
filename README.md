# `home.nix`

```
sudo apt install build-essential curl wget git kitty

git clone git@github.com:fnune/home.nix.git ~/.home.nix

sh <(curl -L https://nixos.org/nix/install) --daemon
mkdir -p ~/.config/nix/ ~/.local/state/nix/profiles/
echo "experimental-features = nix-command flakes" > ~/.config/nix/nix.conf

nix run . -- build --flake .
nix run . -- switch --flake .
```
