{ pkgs, config, ... }:
{
  home.packages = [ pkgs.neovim ];
  home.file = {
    ".config/nvim/" = {
      source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.home.nix/programs/neovim/config";
    };
  };

  home.sessionVariables.EDITOR = "nvim";
  home.sessionVariables.SUDO_EDITOR = "nvim";
  home.sessionVariables.VISUAL = "nvim";
  programs.git.extraConfig.user.editor = "nvim";
  programs.zsh.shellAliases.vim = "nvim";
}
