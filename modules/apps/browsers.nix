{ pkgs-unstable, ... }:
{
  home = {
    sessionVariables.MOZ_ENABLE_WAYLAND = "1";
    packages = with pkgs-unstable; [
      chromium
      firefox
      (thunderbird.override {
        extraPrefs = ''
          lockPref("mailnews.database.global.indexer.enabled", true);
          lockPref("gloda.show_as_list_by_default", true);
          lockPref("gloda.facetview.sortby", 3);
          lockPref("mailnews.database.global.search.msg.limit", 10000);
        '';
      })
    ];
  };
}
