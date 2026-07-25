{config, ...}: {
  home = {
    file."${config.home.homeDirectory}/.ideavimrc".source = ./ideavimrc;
  };
}
