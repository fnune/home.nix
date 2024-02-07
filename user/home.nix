{...}: {
  home = {
    username = "fausto";
    homeDirectory = "/home/fausto";
    stateVersion = "23.05";
  };

  programs.home-manager.enable = true;
  targets.genericLinux.enable = true;
  news.display = "silent";

  imports = [
    ./desktop/applications.nix
    ./desktop/gnome.nix
    ./desktop/mono.nix
    ./desktop/sans.nix
    ./hardware/c920.nix
    ./options.nix
    ./programs/bat.nix
    ./programs/direnv.nix
    ./programs/editorconfig.nix
    ./programs/espanso.nix
    ./programs/fd.nix
    ./programs/fortune.nix
    ./programs/fzf.nix
    ./programs/git.nix
    ./programs/javascript.nix
    ./programs/kitty.nix
    ./programs/neovim/neovim.nix
    ./programs/nvd/nvd.nix
    ./programs/obs-studio.nix
    ./programs/psql/psql.nix
    ./programs/python.nix
    ./programs/rbenv.nix
    ./programs/ripgrep.nix
    ./programs/rust.nix
    ./programs/thunderbird.nix
    ./programs/tmux/tmux.nix
    ./programs/zsh.nix
    ./themes/vscode.nix
    ./work/work.nix
  ];
}
