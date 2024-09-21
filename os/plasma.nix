{pkgs, ...}: let
  wallpaper = pkgs.stdenvNoCC.mkDerivation {
    name = "wallpaper";
    src = ../assets;
    dontUnpack = true;
    installPhase = ''
      mkdir -p $out/share/wallpapers
      cp $src/kedi.jpg $out/share/wallpapers/kedi.jpg
    '';
  };
  wallpaper-sddm = pkgs.writeTextDir "share/sddm/themes/breeze/theme.conf.user" ''
    [General]
    background=${wallpaper}/share/wallpapers/kedi.jpg
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

  environment.systemPackages = [
    pkgs.development.kdePackages.koi
    pkgs.simp1e-cursors
    wallpaper
    wallpaper-sddm
  ];
}
