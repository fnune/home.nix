let
  portalPreferences = {
    "widget.use-xdg-desktop-portal.file-picker" = 1;
    "widget.use-xdg-desktop-portal.location" = 1;
    "widget.use-xdg-desktop-portal.mime-handler" = 1;
    "widget.use-xdg-desktop-portal.open-uri" = 1;
    "widget.use-xdg-desktop-portal.settings" = 1;
  };

  firefoxExtensions = {
    "{d634138d-c276-4fc8-924b-40a0ea21d284}" = "1password-x-password-manager";
    "{446900e4-71c2-419f-a6a7-df9c091e268b}" = "bitwarden-password-manager";
    "addon@darkreader.org" = "darkreader";
    "idcac-pub@guus.ninja" = "istilldontcareaboutcookies";
    "{9063c2e9-e07c-4c2c-9646-cfe7ca8d0498}" = "old-reddit-redirect";
    "sponsorBlocker@ajay.app" = "sponsorblock";
    "{d7742d87-e61d-4b78-b8a1-b469842139fa}" = "vimium-ff";
    "uBlock0@raymondhill.net" = "ublock-origin";
  };

  firefoxForceInstallEntries = builtins.mapAttrs (_: slug: {
    installation_mode = "force_installed";
    install_url = "https://addons.mozilla.org/firefox/downloads/latest/${slug}/latest.xpi";
  }) firefoxExtensions;

  zoomOrigins = [
    "https://app.zoom.us"
    "https://google.zoom.us"
    "https://pulumi.zoom.us"
    "https://us02web.zoom.us"
    "https://us04web.zoom.us"
    "https://us05web.zoom.us"
    "https://us06web.zoom.us"
    "https://www.zoom.us"
    "https://zoom.us"
  ];

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
      Remove = [
        "Bing"
        "Ecosia"
        "Google"
        "Perplexity"
        "Wikipedia (en)"
      ];
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
    Permissions = {
      Camera.Allow = zoomOrigins;
      Microphone.Allow = zoomOrigins;
    };
    Preferences = {
      "browser.aboutConfig.showWarning" = false;
      "browser.translations.automaticallyPopup" = false;
      "browser.urlbar.resultMenu.keyboardAccessible" = false;
      "browser.urlbar.suggest.engines" = false;
      "browser.urlbar.suggest.quickactions" = false;
      "browser.urlbar.suggest.searches" = false;
      "browser.urlbar.suggest.topsites" = false;
      "datareporting.policy.dataSubmissionEnabled" = false;
      "media.navigator.video.default_height" = 360;
      "media.navigator.video.default_width" = 640;
      "media.webrtc.camera.allow-pipewire" = true;
      "widget.use-xdg-desktop-portal.native-messaging" = 1;
    }
    // portalPreferences;
    ExtensionSettings = firefoxForceInstallEntries // {
      "*" = {
        installation_mode = "allowed";
        allowed_types = [ "theme" ];
        blocked_install_message = "Install extensions declaratively via home-manager.";
      };
    };
  };

  thunderbirdPolicies = {
    SearchEngines = {
      Default = "DuckDuckGo";
    };
    Preferences = portalPreferences // {
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

  chromeExtensionIds = {
    claudeInChrome = "fcoeoabgfenejglbffodgkkbkcdhcgfn";
    uBlockOriginLite = "ddkjiahejlhfcafbddmgiahcphecmpfh";
  };

  chromiumPolicies = {
    BackgroundModeEnabled = false;
    AIModeSettings = 1;
    BookmarkBarEnabled = false;
    DefaultBrowserSettingEnabled = false;
    DefaultSearchProviderEnabled = true;
    DefaultSearchProviderName = "DuckDuckGo";
    DefaultSearchProviderKeyword = "duckduckgo.com";
    DefaultSearchProviderSearchURL = "https://duckduckgo.com/?q={searchTerms}";
    DefaultSearchProviderSuggestURL = "https://duckduckgo.com/ac/?q={searchTerms}&type=list";
    FeedbackSurveysEnabled = false;
    GeminiSettings = 1;
    GenAiDefaultSettings = 2;
    HomepageIsNewTabPage = false;
    MediaRecommendationsEnabled = false;
    MetricsReportingEnabled = false;
    NewTabPageLocation = "about:blank";
    PasswordManagerEnabled = false;
    PrivacySandboxAdMeasurementEnabled = false;
    PrivacySandboxAdTopicsEnabled = false;
    PrivacySandboxPromptEnabled = false;
    PrivacySandboxSiteEnabledAdsEnabled = false;
    PromotionsEnabled = false;
    SafeBrowsingSurveysEnabled = false;
    SearchSuggestEnabled = false;
    ShoppingListEnabled = false;
    ShowHomeButton = false;
    SigninInterceptionEnabled = false;
    UrlKeyedAnonymizedDataCollectionEnabled = false;
    UserFeedbackAllowed = false;
    ExtensionInstallBlocklist = [ "*" ];
    ExtensionInstallForcelist = [ chromeExtensionIds.uBlockOriginLite ];
  };
in
{
  firefox = firefoxPolicies;
  thunderbird = thunderbirdPolicies;
  chromium = chromiumPolicies;
  chrome = chromiumPolicies // {
    ExtensionInstallForcelist = chromiumPolicies.ExtensionInstallForcelist ++ [
      chromeExtensionIds.claudeInChrome
    ];
  };
}
