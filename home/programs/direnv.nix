_: {
  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    silent = true;
  };
  home.sessionVariables = {
    DIRENV_WARN_TIMEOUT = "10000h";
  };
}
