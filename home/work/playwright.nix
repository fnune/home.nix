{pkgs, ...}: let
  playwright-browsers = pkgs.callPackage ../../packages/playwright-browsers.nix {
    version = "1.48.1";
    sha256 = "sha256-VMp/Tjd5w2v+IHD+CMaR/XdMJHkS/u7wFe0hNxa1TbE";
  };
in {
  home = {
    packages = [playwright-browsers];
    sessionVariables = {
      PLAYWRIGHT_BROWSERS_PATH = "${playwright-browsers}";
      PLAYWRIGHT_SKIP_VALIDATE_HOST_REQUIREMENTS = "true";
    };
  };
}
