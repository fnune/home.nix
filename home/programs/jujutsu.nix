{
  config,
  pkgs,
  ...
}: {
  home.packages = [pkgs.jjui];

  programs.jujutsu = {
    enable = true;
    settings = {
      user = {
        name = config.profile.name;
        email = config.profile.email.personal;
      };
      signing = {
        behavior = "own";
        backend = "ssh";
        key = "${config.profile.sshKeyPath}.pub";
      };
      ui.default-command = "log";
    };
  };
}
