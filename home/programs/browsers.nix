{pkgs, ...}: {
  home = {
    sessionVariables.MOZ_USE_XINPUT2 = "1"; # Improves trackpad scrolling in FF
    sessionVariables.MOZ_ENABLE_WAYLAND = "1"; # Sometimes FF launches under XWayland otherwise
  };

  programs.firefox = {
    enable = true;
    package = pkgs.unstable.firefox;
    profiles = {
      default = {
        name = "Default";
        isDefault = true;
        settings = {
          "extensions.autoDisableScopes" = 0;
          "services.sync.username" = "fausto.nunez@mailbox.org";
        };
        extensions = {
          packages = with pkgs.nur.repos.rycee.firefox-addons; [
            bitwarden
            istilldontcareaboutcookies
            onepassword-password-manager
            sponsorblock
            ublock-origin
            vimium
            zoom-redirector
          ];
        };
      };
    };
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
      };
      Preferences = {
        "browser.aboutConfig.showWarning" = false;
        "browser.search.suggest.enabled" = false;
        "browser.sessionstore.max_resumed_crashes" = -1;
        "browser.tabs.hoverPreview.enabled" = false;
        "browser.translations.automaticallyPopup" = false;
        "browser.urlbar.resultMenu.keyboardAccessible" = false;
        "browser.urlbar.shortcuts.bookmarks" = false;
        "browser.urlbar.shortcuts.history" = false;
        "browser.urlbar.shortcuts.tabs" = false;
        "sidebar.verticalTabs" = true;
        "widget.use-xdg-desktop-portal" = true;
        "widget.use-xdg-desktop-portal.file-picker" = 1;
        "widget.wayland.fractional-scale.enabled" = true;
      };
    };
  };

  programs.chromium = {
    enable = true;
    extensions = [
      {id = "aeblfdkhhhdcdjpifhhbdiojplfjncoa";} # 1Password
      {id = "ddkjiahejlhfcafbddmgiahcphecmpfh";} # uBlock Origin Lite
      {id = "dpjamkmjmigaoobjbekmfgabipmfilij";} # Empty new tab page
      {id = "nngceckbapebfimnlniiiahkandclblb";} # Bitwarden
    ];
  };
}
