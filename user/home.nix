{...}: {
  home.username = "fausto";
  home.homeDirectory = "/home/fausto";
  home.stateVersion = "23.05";

  programs.home-manager.enable = true;
  targets.genericLinux.enable = true;

  imports = [
    ./desktop/applications.nix
    ./desktop/mono.nix
    ./desktop/plasma.nix
    ./desktop/sans.nix
    ./hardware/c920.nix
    ./options.nix
    ./programs/bat.nix
    ./programs/direnv.nix
    ./programs/editorconfig.nix
    ./programs/fd.nix
    ./programs/flameshot.nix
    ./programs/fzf.nix
    ./programs/git.nix
    ./programs/kitty.nix
    ./programs/neovim/neovim.nix
    ./programs/psql/psql.nix
    ./programs/python.nix
    ./programs/rbenv.nix
    ./programs/ripgrep.nix
    ./programs/rust.nix
    ./programs/tmux/tmux.nix
    ./programs/zsh.nix
    ./themes/vscode.nix
    ./work/work.nix
  ];
}
