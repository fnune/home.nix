{pkgs, ...}: let
  portalPreferences = {
    "widget.use-xdg-desktop-portal.file-picker" = 1;
    "widget.use-xdg-desktop-portal.location" = 1;
    "widget.use-xdg-desktop-portal.mime-handler" = 1;
    "widget.use-xdg-desktop-portal.open-uri" = 1;
    "widget.use-xdg-desktop-portal.settings" = 1;
  };

  firefoxPolicies = {
    DisableTelemetry = true;
    DisableFirefoxStudies = true;
    DisableFeedbackCommands = true;
    NewTabPage = false;
    NoDefaultBookmarks = true;
    OfferToSaveLogins = false;
    PasswordManagerEnabled = false;
    DisplayBookmarksToolbar = "never";
    Homepage = {
      URL = "about:blank";
      StartPage = "none";
    };
    SearchEngines = {
      Default = "DuckDuckGo";
      Remove = ["Bing" "Ecosia" "Google" "Perplexity" "Wikipedia (en)"];
    };
    FirefoxHome = {
      Highlights = false;
      Locked = true;
      Pocket = false;
      Search = false;
      Snippets = false;
      SponsoredPocket = false;
      SponsoredTopSites = false;
      TopSites = false;
    };
    FirefoxSuggest = {
      ImproveSuggest = false;
      Locked = true;
      SponsoredSuggestions = false;
      WebSuggestions = false;
    };
    GenerativeAI = {
      Chatbot = false;
      LinkPreviews = false;
      Locked = true;
      TabGroups = false;
    };
    UserMessaging = {
      ExtensionRecommendations = false;
      FeatureRecommendations = false;
      FirefoxLabs = false;
      Locked = true;
      MoreFromMozilla = false;
      SkipOnboarding = true;
      UrlbarInterventions = false;
    };
    Preferences =
      {
        "browser.aboutConfig.showWarning" = false;
        "browser.translations.automaticallyPopup" = false;
        "browser.urlbar.resultMenu.keyboardAccessible" = false;
        "browser.urlbar.suggest.engines" = false;
        "browser.urlbar.suggest.quickactions" = false;
        "browser.urlbar.suggest.searches" = false;
        "browser.urlbar.suggest.topsites" = false;
        "datareporting.policy.dataSubmissionEnabled" = false;
        "widget.use-xdg-desktop-portal.native-messaging" = 1;
      }
      // portalPreferences;
  };

  policiesJson = pkgs.writeText "firefox-policies.json" (builtins.toJSON {
    policies = firefoxPolicies;
  });

  chromiumPolicies = {
    BackgroundModeEnabled = false;
    BookmarkBarEnabled = false;
    DefaultSearchProviderEnabled = true;
    DefaultSearchProviderName = "DuckDuckGo";
    DefaultSearchProviderSearchURL = "https://duckduckgo.com/?q={searchTerms}";
    DefaultSearchProviderSuggestURL = "https://duckduckgo.com/ac/?q={searchTerms}&type=list";
    HomepageIsNewTabPage = false;
    MetricsReportingEnabled = false;
    PasswordManagerEnabled = false;
    SearchSuggestEnabled = false;
    ShowHomeButton = false;
    UserFeedbackAllowed = false;
  };

  chromiumPoliciesJson = pkgs.writeText "chromium-policies.json" (builtins.toJSON chromiumPolicies);

  thunderbirdPolicies = {
    Preferences = portalPreferences;
  };

  thunderbirdPoliciesJson = pkgs.writeText "thunderbird-policies.json" (builtins.toJSON {
    policies = thunderbirdPolicies;
  });

  installBrowserPolicies = pkgs.writeShellScriptBin "install-browser-policies" ''
    #!/usr/bin/env sh
    set -e
    echo "Installing Firefox policies system-wide..."
    sudo mkdir -p /etc/firefox/policies
    sudo cp ${policiesJson} /etc/firefox/policies/policies.json
    echo "Firefox policies installed to /etc/firefox/policies/policies.json"

    echo ""
    echo "Installing Chromium policies system-wide..."
    sudo mkdir -p /etc/chromium/policies/managed
    sudo cp ${chromiumPoliciesJson} /etc/chromium/policies/managed/policies.json
    echo "Chromium policies installed to /etc/chromium/policies/managed/policies.json"

    echo ""
    echo "Installing Thunderbird policies system-wide..."
    sudo cp ${thunderbirdPoliciesJson} /usr/lib/thunderbird/distribution/policies.json
    echo "Thunderbird policies installed to /usr/lib/thunderbird/distribution/policies.json"

    echo ""
    echo "Done! Restart browsers and visit:"
    echo "  - Firefox: about:policies"
    echo "  - Chromium: chrome://policy"
    echo "  - Thunderbird: Help > Troubleshooting Information > Policies"
  '';
in {
  home = {
    sessionVariables.MOZ_ENABLE_WAYLAND = "1";
    packages = [installBrowserPolicies];
  };

  services.pacman.packages = ["firefox" "chromium"];
}
