{
  pkgs,
  lib,
  ...
}: {
  home = {
    username = "fausto";
    homeDirectory = "/home/fausto";
    stateVersion = "23.05";
  };

  programs.home-manager.enable = true;
  targets.genericLinux.enable = true;
  news.display = "silent";
  nix.gc = {
    automatic = true;
    options = "--delete-older-than 10d";
  };

  home.sessionVariables = {
    NIX_LD_LIBRARY_PATH = lib.makeLibraryPath [pkgs.stdenv.cc.cc pkgs.openssl];
    NIX_LD = lib.fileContents "${pkgs.stdenv.cc}/nix-support/dynamic-linker";
  };

  imports = [
    ./desktop/applications.nix
    ./desktop/audio.nix
    ./desktop/gnome.nix
    ./desktop/mono.nix
    ./desktop/sans.nix
    ./options.nix
    ./programs/bat.nix
    ./programs/chess.nix
    ./programs/direnv.nix
    ./programs/editorconfig.nix
    ./programs/fd.nix
    ./programs/fortune.nix
    ./programs/fzf.nix
    ./programs/git.nix
    ./programs/javascript.nix
    ./programs/kitty.nix
    ./programs/maestral.nix
    ./programs/neovim/neovim.nix
    ./programs/nvd/nvd.nix
    ./programs/obs-studio.nix
    ./programs/playwright.nix
    ./programs/psql/psql.nix
    ./programs/python.nix
    ./programs/rbenv.nix
    ./programs/ripgrep.nix
    ./programs/rust.nix
    ./programs/satty.nix
    ./programs/slack.nix
    ./programs/thunderbird.nix
    ./programs/tmux/tmux.nix
    ./programs/ventoy.nix
    ./programs/zsh.nix
    ./work/work.nix
  ];
}
