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
    ./desktop/audio.nix
    ./desktop/fonts.nix
    ./desktop/plasma.nix
    ./options.nix
    ./programs/bat.nix
    ./programs/devenv.nix
    ./programs/direnv.nix
    ./programs/editorconfig.nix
    ./programs/fd.nix
    ./programs/fzf.nix
    ./programs/git.nix
    ./programs/kitty/kitty.nix
    ./programs/neovim/neovim.nix
    ./programs/obs-studio.nix
    ./programs/pcloud.nix
    ./programs/playwright.nix
    ./programs/psql/psql.nix
    ./programs/python.nix
    ./programs/ripgrep.nix
    ./programs/rust.nix
    ./programs/slack.nix
    ./programs/thunderbird.nix
    ./programs/tmux/tmux.nix
    ./programs/ventoy.nix
    ./programs/zsh.nix
    ./work/work.nix
  ];
}
