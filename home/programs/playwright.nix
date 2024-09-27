{pkgs, ...}: let
  playwright-browsers = pkgs.callPackage ./playwright-browsers.nix {
    version = "1.47.1";
    sha256 = "sha256-tPlzDBxDunUrQFqJZTc6FS+pUkww5x9IpWtCvNIS8Mg";
  };
in {
  home.packages = [playwright-browsers];
  home.sessionVariables = {
    PLAYWRIGHT_BROWSERS_PATH = "${playwright-browsers}";
    PLAYWRIGHT_SKIP_VALIDATE_HOST_REQUIREMENTS = "true";
  };
}
