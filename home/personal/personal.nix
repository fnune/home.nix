{config, ...}: {
  home = {
    file = {
      "${config.home.homeDirectory}/.zsh/includes/n".source = ./launch.sh;
    };
  };
}
