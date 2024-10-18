{config, ...}: {
  programs = {
    bat = {
      enable = true;
      config.theme =
        if config.colorscheme == "vscode"
        then "Visual Studio Dark+"
        else false;
    };
    zsh.shellAliases.cat = "bat";
  };
}
