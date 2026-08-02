{ ... }: {
  imports = [
    ./bat.nix
    ./direnv.nix
    ./fzf.nix
    ./networking.nix
    ./ripgrep.nix
    ./utils.nix
    ./zsh.nix
    ./herdr
    ./kitty/kitty.nix
    ./vivid/vivid.nix
  ];
}
