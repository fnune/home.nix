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

  home.sessionVariables = {
    NIX_LD_LIBRARY_PATH = lib.makeLibraryPath [pkgs.stdenv.cc.cc pkgs.openssl];
    NIX_LD = lib.fileContents "${pkgs.stdenv.cc}/nix-support/dynamic-linker";
  };

  imports = [
    ./desktop/applications.nix
    ./desktop/gnome.nix
    ./desktop/mono.nix
    ./desktop/sans.nix
    ./options.nix
    ./programs/bat.nix
    ./programs/direnv.nix
    ./programs/editorconfig.nix
    ./programs/fd.nix
    ./programs/fortune.nix
    ./programs/fzf.nix
    ./programs/git.nix
    ./programs/javascript.nix
    ./programs/kitty.nix
    ./programs/ksnip.nix
    ./programs/maestral.nix
    ./programs/neovim/neovim.nix
    ./programs/nvd/nvd.nix
    ./programs/obs-studio.nix
    ./programs/playwright.nix
    ./programs/psql/psql.nix
    ./programs/python.nix
    ./programs/rbenv.nix
    ./programs/restream.nix
    ./programs/ripgrep.nix
    ./programs/rust.nix
    ./programs/slack.nix
    ./programs/thunderbird.nix
    ./programs/tmux/tmux.nix
    ./programs/zsh.nix
    ./work/work.nix
  ];
}
