{ pkgs, ... }:
let
  extensionIds = {
    claudeInChrome = "fcoeoabgfenejglbffodgkkbkcdhcgfn";
    uBlockOrigin = "cjpalhdlnbpafiamejdnhcphjbkeiagm";
  };

  chromiumPolicies = {
    BackgroundModeEnabled = false;
    BookmarkBarEnabled = false;
    DefaultSearchProviderEnabled = true;
    DefaultSearchProviderName = "Kagi";
    DefaultSearchProviderKeyword = "kagi";
    DefaultSearchProviderSearchURL = "https://kagi.com/search?q={searchTerms}";
    DefaultSearchProviderSuggestURL = "https://kagi.com/api/autosuggest?q={searchTerms}";
    HomepageIsNewTabPage = false;
    MetricsReportingEnabled = false;
    PasswordManagerEnabled = false;
    SearchSuggestEnabled = false;
    ShowHomeButton = false;
    UserFeedbackAllowed = false;
    ExtensionInstallBlocklist = [ "*" ];
    ExtensionInstallForcelist = [ extensionIds.uBlockOrigin ];
  };

  chromePolicies = chromiumPolicies // {
    ExtensionInstallForcelist = chromiumPolicies.ExtensionInstallForcelist ++ [
      extensionIds.claudeInChrome
    ];
  };

  chromiumPoliciesJson = pkgs.writeText "chromium-policies.json" (builtins.toJSON chromiumPolicies);
  chromePoliciesJson = pkgs.writeText "chrome-policies.json" (builtins.toJSON chromePolicies);

  installChromePolicies = pkgs.writeShellScriptBin "install-chrome-policies" ''
    set -e
    echo "Installing Chromium policies system-wide..."
    sudo mkdir -p /etc/chromium/policies/managed
    sudo cp ${chromiumPoliciesJson} /etc/chromium/policies/managed/policies.json
    echo "Chromium policies installed to /etc/chromium/policies/managed/policies.json"

    echo ""
    echo "Installing Google Chrome policies system-wide..."
    sudo mkdir -p /etc/opt/chrome/policies/managed
    sudo cp ${chromePoliciesJson} /etc/opt/chrome/policies/managed/policies.json
    echo "Google Chrome policies installed to /etc/opt/chrome/policies/managed/policies.json"
  '';
in
{
  home.packages = [
    installChromePolicies
    pkgs.google-chrome
  ];
}
