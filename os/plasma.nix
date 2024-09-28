{pkgs, ...}: let
  wallpaper = pkgs.stdenvNoCC.mkDerivation {
    name = "wallpaper";
    src = ../assets;
    dontUnpack = true;
    installPhase = ''
      mkdir -p $out/share/wallpapers
      cp -R $src/Kedi $out/share/wallpapers/Kedi
    '';
  };
  wallpaper-sddm = pkgs.writeTextDir "share/sddm/themes/breeze/theme.conf.user" ''
    [General]
    background=${wallpaper}/share/wallpapers/Kedi/contents/images/5120x2880.jpg
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

  # https://blog.aktsbot.in/no-more-blurry-fonts.html
  environment.sessionVariables.FREETYPE_PROPERTIES = "cff:no-stem-darkening=0 autofitter:no-stem-darkening=0";
}
