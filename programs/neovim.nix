{ config, pkgs, lib, ... }:
let
  dotfiles = pkgs.fetchgit {
    url = "https://github.com/fnune/dotfiles.git";
    rev = "refs/heads/master";
    sparseCheckout = [ "neovim/.config/nvim" ];
    sha256 = "sha256-dy/o1bExUo05mLEOXhcL81SArf5dFIXCjAfqpAb8ZvA";
  };
  dotnvim = "${config.home.homeDirectory}/.nvim";
in
{
  home.packages = [ pkgs.neovim ];

  # TODO: Connect 'dotnvim' to a new repository & transfer history
  # from the existing dotfiles repository.
  home.activation.copyNeovimConfig = lib.hm.dag.entryAfter ["writeBoundary"] ''
    cp -r ${dotfiles}/neovim/.config/nvim ${dotnvim}
    chmod -R +w ${dotnvim}
  '';

  home.file.".config/nvim".source = config.lib.file.mkOutOfStoreSymlink dotnvim;

  home.sessionVariables.EDITOR = "nvim";
  home.sessionVariables.SUDO_EDITOR = "nvim";
  home.sessionVariables.VISUAL = "nvim";
  programs.git.extraConfig.user.editor = "nvim";
  programs.zsh.shellAliases.vim = "nvim";
}
