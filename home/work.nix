{pkgs, ...}: {
  home.packages = with pkgs.unstable; [
    _1password-gui
    awscli2
    pulumi-esc
    slack
    zoom-us
  ];
}
