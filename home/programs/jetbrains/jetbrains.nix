{pkgs, config, ...}: {
  home = {
    file."${config.home.homeDirectory}/.ideavimrc".source = ./ideavimrc;
    packages = [pkgs.jetbrains-toolbox];
  };
}
