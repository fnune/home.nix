{...}: {
  programs = {
    bat.enable = true;
    zsh.shellAliases.cat = "bat";

    direnv.enable = true;
  };
}
