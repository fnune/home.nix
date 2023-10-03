{...}: {
  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
  };
  home.sessionVariables = {
    DIRENV_LOG_FORMAT = "";
    DIRENV_WARN_TIMEOUT = "10000h";
  };
}
