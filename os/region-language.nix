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
    geoclue2 = {
      enable = true;
      # https://github.com/NixOS/nixpkgs/pull/391845
      geoProviderUrl = "https://api.beacondb.net/v1/geolocate";
      submissionUrl = "https://api.beacondb.net/v2/geosubmit";
    };
    xserver.xkb = {
      inherit layout;
      variant = "";
    };
  };
}
