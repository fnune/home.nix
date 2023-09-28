{...}: {
  home.username = "fausto";
  home.homeDirectory = "/home/fausto";
  home.stateVersion = "23.05";

  programs.home-manager.enable = true;

  imports = [
    ./desktop/gnome.nix
    ./hardware/c920.nix
    ./programs/editorconfig.nix
    ./programs/flameshot.nix
    ./programs/fzf.nix
    ./programs/git.nix
    ./programs/kitty.nix
    ./programs/neovim/neovim.nix
    ./programs/ripgrep.nix
    ./programs/rust.nix
    ./programs/tmux/tmux.nix
    ./programs/utils.nix
    ./programs/zsh.nix
    ./themes/vscode.nix
    ./work/work.nix
  ];
}
