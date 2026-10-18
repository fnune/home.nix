_:
let
  browserPolicies = import ../modules/apps/browser-policies.nix;
in
{
  environment.etc."opt/chrome/policies/managed/policies.json" = {
    text = builtins.toJSON browserPolicies.chrome;
    replaceExisting = true;
  };
}
