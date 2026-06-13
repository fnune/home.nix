{pkgs, ...}: let
  portalPreferences = {
    "widget.use-xdg-desktop-portal.file-picker" = 1;
    "widget.use-xdg-desktop-portal.location" = 1;
    "widget.use-xdg-desktop-portal.mime-handler" = 1;
    "widget.use-xdg-desktop-portal.open-uri" = 1;
    "widget.use-xdg-desktop-portal.settings" = 1;
  };

  firefoxExtensionIds = {
    onePassword = "{d634138d-c276-4fc8-924b-40a0ea21d284}";
    bitwarden = "{446900e4-71c2-419f-a6a7-df9c091e268b}";
    darkReader = "addon@darkreader.org";
    multiAccountContainers = "@testpilot-containers";
    iStillDontCareAboutCookies = "idcac-pub@guus.ninja";
    oldRedditRedirect = "{9063c2e9-e07c-4c2c-9646-cfe7ca8d0498}";
    sponsorBlock = "sponsorBlocker@ajay.app";
    vimium = "{d7742d87-e61d-4b78-b8a1-b469842139fa}";
    uBlockOrigin = "uBlock0@raymondhill.net";
  };

  firefoxAllowedExtensions = with firefoxExtensionIds; [
    onePassword
    bitwarden
    darkReader
    multiAccountContainers
    iStillDontCareAboutCookies
    oldRedditRedirect
    sponsorBlock
    vimium
  ];

  firefoxAllowEntries =
    builtins.listToAttrs
    (map (id: {
        name = id;
        value = {installation_mode = "allowed";};
      })
      firefoxAllowedExtensions);

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
    ExtensionSettings =
      firefoxAllowEntries
      // {
        "*" = {
          installation_mode = "blocked";
          blocked_install_message = "Install extensions declaratively via home-manager.";
        };
        ${firefoxExtensionIds.uBlockOrigin} = {
          installation_mode = "force_installed";
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
        };
      };
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
    ExtensionInstallBlocklist = ["*"];
    ExtensionInstallForcelist = ["cjpalhdlnbpafiamejdnhcphjbkeiagm"];
  };

  chromiumPoliciesJson = pkgs.writeText "chromium-policies.json" (builtins.toJSON chromiumPolicies);

  thunderbirdPolicies = {
    SearchEngines = {
      Default = "DuckDuckGo";
    };
    Preferences =
      portalPreferences
      // {
        "mailnews.start_page.enabled" = {
          Value = false;
          Status = "locked";
        };
        "mail.shell.checkDefaultClient" = {
          Value = false;
          Status = "locked";
        };
      };
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
