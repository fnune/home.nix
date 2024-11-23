{
  pkgs,
  config,
  ...
}: let
  wallpaper-sddm = pkgs.writeTextDir "share/sddm/themes/breeze/theme.conf.user" ''
    [General]
    type=color
    color=#212121
    background=
  '';
in {
  services = {
    desktopManager.plasma6.enable = true;
    displayManager = {
      defaultSession = "plasma";
      sddm = {
        enable = true;
        wayland.enable = true;
        settings = {
          Theme = {
            Font = config.fontconfig.sans;
            CursorTheme = config.cursors.name;
          };
        };
      };
    };
  };

  environment.plasma6.excludePackages = with pkgs.kdePackages; [
    elisa
    khelpcenter
    konsole
  ];

  programs = {
    kdeconnect.enable = true;
    gnupg.agent.pinentryPackage = pkgs.callPackage ../packages/pinentry-kwallet.nix {};
  };

  environment.systemPackages = [
    pkgs.kdePackages.koi
    wallpaper-sddm
  ];
}
