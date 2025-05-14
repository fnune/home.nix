{
  pkgs,
  config,
  ...
}: let
  service = "${config.home.homeDirectory}/Development/pulumi-service";
in {
  home = {
    packages = with pkgs.unstable; [
      _1password-gui
      awscli2
      go
      mysql80
      pulumi-esc
      slack
      zoom-us
    ];

    file."${service}/.nvim.lua".source = ./work.lua;
  };
}
