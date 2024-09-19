{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    firefox-devedition
    google-chrome
  ];

  programs.firefox = {
    # Browser configuration
    enable = true;
    policies = {
      DisableAppUpdate = true;
      DisablePocket = true;
      DisplayBookmarksToolbar = "never";
      Homepage.StartPage = "none";
      PasswordManagerEnabled = false;
      SearchEngines.Default = "DuckDuckGo";
      Preferences = {
        "browser.aboutConfig.showWarning" = false;
        "browser.search.suggest.enabled" = false;
        "browser.sessionstore.max_resumed_crashes" = -1;
        "browser.translations.automaticallyPopup" = false;
        "browser.urlbar.resultMenu.keyboardAccessible" = false;
        "services.sync.username" = "fausto.nunez@mailbox.org";
        "widget.use-xdg-desktop-portal" = true;
        "widget.use-xdg-desktop-portal.file-picker" = 1;
      };
    };
  };
  environment.sessionVariables.MOZ_USE_XINPUT2 = "1"; # Improves trackpad scrolling in FF
  environment.sessionVariables.MOZ_ENABLE_WAYLAND = "1"; # Sometimes FF launches under XWayland otherwise
}
