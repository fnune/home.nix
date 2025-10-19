{pkgs, ...}: let
  firefoxPolicies = {
    DisableTelemetry = true;
    NewTabPage = false;
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
    Preferences = {
      "browser.aboutConfig.showWarning" = false;
      "browser.translations.automaticallyPopup" = false;
      "browser.urlbar.resultMenu.keyboardAccessible" = false;
      "browser.urlbar.suggest.engines" = false;
      "browser.urlbar.suggest.quickactions" = false;
      "browser.urlbar.suggest.searches" = false;
      "browser.urlbar.suggest.topsites" = false;
      "datareporting.healthreport.uploadEnabled" = false;
      "datareporting.policy.dataSubmissionEnabled" = false;
      "widget.use-xdg-desktop-portal.file-picker" = 1;
      "widget.use-xdg-desktop-portal.location" = 1;
      "widget.use-xdg-desktop-portal.mime-handler" = 1;
      "widget.use-xdg-desktop-portal.native-messaging" = 1;
      "widget.use-xdg-desktop-portal.open-uri" = 1;
      "widget.use-xdg-desktop-portal.settings" = 1;
    };
  };

  policiesJson = pkgs.writeText "firefox-policies.json" (builtins.toJSON {
    policies = firefoxPolicies;
  });

  installFirefoxPolicies = pkgs.writeShellScriptBin "install-firefox-policies" ''
    #!/usr/bin/env sh
    set -e
    echo "Installing Firefox policies system-wide..."
    sudo mkdir -p /etc/firefox/policies
    sudo cp ${policiesJson} /etc/firefox/policies/policies.json
    echo "Firefox policies installed to /etc/firefox/policies/policies.json"
    echo "Restart Firefox and visit about:policies to verify."
  '';
in {
  home = {
    sessionVariables.MOZ_ENABLE_WAYLAND = "1";
    packages = [installFirefoxPolicies];
  };

  services.pacman.packages = ["firefox" "chromium"];
}
