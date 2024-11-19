{pkgs, ...}: let
  wallpaper-sddm = pkgs.writeTextDir "share/sddm/themes/breeze/theme.conf.user" ''
    [General]
    type=color
    color=#212121
    background=
  '';
in {
  services.displayManager = {
    defaultSession = "plasma";
    sddm = {
      enable = true;
      wayland.enable = true;
      settings = {
        Theme = {
          Font = "Inter";
          CursorTheme = "Simp1e-Adw-Dark";
        };
      };
    };
  };
  services.desktopManager.plasma6.enable = true;
  environment.plasma6.excludePackages = with pkgs.kdePackages; [konsole];
  programs.kdeconnect.enable = true;
  programs.gnupg.agent.pinentryPackage = pkgs.callPackage ./pinentry-kwallet.nix {};

  environment.systemPackages = [
    pkgs.kdePackages.koi
    pkgs.simp1e-cursors
    wallpaper-sddm
  ];
}
