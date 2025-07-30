{config, ...}: {
  services.flatpak.packages = [
    "com.jetbrains.DataGrip"
    "com.jetbrains.GoLand"
  ];

  home = {
    file."${config.home.homeDirectory}/.ideavimrc".source = ./ideavimrc;
  };
}
