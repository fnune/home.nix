_:
let
  browserPolicies = import ../modules/apps/browser-policies.nix;

  etcJson = value: {
    text = builtins.toJSON value;
    replaceExisting = true;
  };

  highestDefaultV4l2Priority = 1000; # https://gitlab.freedesktop.org/pipewire/wireplumber/-/blob/0.5.18/src/scripts/monitors/v4l2/name-node.lua#L75
in
{
  imports = [
    ./base.nix
    ./clack.nix
  ];

  environment.etc = {
    "firefox/policies/policies.json" = etcJson { policies = browserPolicies.firefox; };
    "thunderbird/policies/policies.json" = etcJson { policies = browserPolicies.thunderbird; };
    "chromium/policies/managed/policies.json" = etcJson browserPolicies.chromium;
    "wireplumber/wireplumber.conf.d/51-prefer-obsbot.conf" = etcJson {
      "monitor.v4l2.rules" = [
        {
          matches = [ { "node.description" = "~OBSBOT*"; } ];
          actions.update-props."priority.session" = highestDefaultV4l2Priority + 1;
        }
      ];
    };
  };
}
