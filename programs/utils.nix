{...}: {
  programs = {
    bat.enable = true;
    zsh.shellAliases.cat = "bat";
  };

  programs.direnv.enable = true;
  programs.direnv.enableZshIntegration = true;
  home.sessionVariables.DIRENV_LOG_FORMAT = "";
}
