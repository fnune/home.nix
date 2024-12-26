_: let
  layout = "es";
in {
  i18n = {
    defaultLocale = "en_US.UTF-8";
    extraLocaleSettings = import ../home/locales.nix;
  };
  console.keyMap = layout;
  services = {
    automatic-timezoned.enable = true;
    xserver.xkb = {
      inherit layout;
      variant = "";
    };
  };
}
