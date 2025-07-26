{
  pkgs,
  config,
  ...
}: {
  home = {
    packages = with pkgs.unstable.jetbrains; [goland datagrip];
    file."${config.home.homeDirectory}/.ideavimrc".source = ./ideavimrc;
  };
}
