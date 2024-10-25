{pkgs, ...}: {
  environment = {
    systemPackages = with pkgs; [firefox-devedition google-chrome];
    sessionVariables.MOZ_USE_XINPUT2 = "1"; # Improves trackpad scrolling in FF
    sessionVariables.MOZ_ENABLE_WAYLAND = "1"; # Sometimes FF launches under XWayland otherwise
  };

  programs.firefox = {
    enable = true;
    policies = {
      DisableAppUpdate = true;
      DisablePocket = true;
      DisplayBookmarksToolbar = "never";
      Homepage.StartPage = "none";
      NewTabPage = false;
      NoDefaultBookmarks = true;
      PasswordManagerEnabled = false;
      SearchEngines = {
        Default = "DuckDuckGo";
        Remove = ["Bing" "Google" "Wikipedia (en)"];
      };
      Preferences = {
        "browser.aboutConfig.showWarning" = false;
        "browser.search.suggest.enabled" = false;
        "browser.sessionstore.max_resumed_crashes" = -1;
        "browser.translations.automaticallyPopup" = false;
        "browser.urlbar.resultMenu.keyboardAccessible" = false;
        "browser.urlbar.shortcuts.bookmarks" = false;
        "browser.urlbar.shortcuts.history" = false;
        "browser.urlbar.shortcuts.tabs" = false;
        "services.sync.username" = "fausto.nunez@mailbox.org";
        "widget.use-xdg-desktop-portal" = true;
        "widget.use-xdg-desktop-portal.file-picker" = 1;
      };
    };
  };
}
