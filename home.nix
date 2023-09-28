{...}: {
  home.username = "fausto";
  home.homeDirectory = "/home/fausto";
  home.stateVersion = "23.05";

  programs.home-manager.enable = true;

  imports = [
    ./themes/vscode.nix
    ./hardware/c920.nix
    ./programs/editorconfig.nix
    ./programs/git.nix
    ./programs/neovim/neovim.nix
    ./programs/tmux/tmux.nix
    ./programs/zsh.nix
    ./programs/utils.nix
    ./programs/kitty/kitty.nix
    ./programs/ripgrep.nix
    ./programs/fzf.nix
    ./work/work.nix
  ];
}
