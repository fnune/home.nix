_:
let
  browserPolicies = import ../modules/apps/browser-policies.nix;

  etcJson = value: {
    text = builtins.toJSON value;
    replaceExisting = true;
  };
in
{
  imports = [ ./chrome.nix ];

  environment.etc = {
    "firefox/policies/policies.json" = etcJson { policies = browserPolicies.firefox; };
    "thunderbird/policies/policies.json" = etcJson { policies = browserPolicies.thunderbird; };
    "chromium/policies/managed/policies.json" = etcJson browserPolicies.chromium;
  };
}
