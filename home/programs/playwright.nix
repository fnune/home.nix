{pkgs, ...}: let
  playwright-browsers = pkgs.callPackage ../../packages/playwright-browsers.nix {
    version = "1.48.2";
    sha256 = "sha256-qKDP8BJVkVMUda4WDtWiVl1PlP33E3gYeSOfPNljZec";
  };
in {
  home.packages = [playwright-browsers];
  home.sessionVariables = {
    PLAYWRIGHT_BROWSERS_PATH = "${playwright-browsers}";
    PLAYWRIGHT_SKIP_VALIDATE_HOST_REQUIREMENTS = "true";
  };
}
