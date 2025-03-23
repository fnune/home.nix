_: {
  programs = {
    bat = {
      enable = true;
      config.theme = "base16"; # Uses terminal colors
    };
    zsh.shellAliases.cat = "bat";
  };
}
