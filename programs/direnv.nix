{...}: {
  programs.direnv.enable = true;
  programs.direnv.enableZshIntegration = true;
  home.sessionVariables.DIRENV_LOG_FORMAT = "";
}
