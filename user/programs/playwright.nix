{pkgs, ...}: let
  playwright = pkgs.unstable.playwright-driver;
in {
  home.packages = [playwright];
  home.sessionVariables = {
    PLAYWRIGHT_BROWSERS_PATH = "${playwright.browsers}";
    PLAYWRIGHT_SKIP_VALIDATE_HOST_REQUIREMENTS = true;
  };
}
