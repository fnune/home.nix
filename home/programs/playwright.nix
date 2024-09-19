{
  config,
  pkgs,
  lib,
  ...
}: let
  dstBrowsersPath = "${config.home.homeDirectory}/.local/share/playwright";
  srcBrowsersPath = pkgs.playwright-driver.browsers;
  dstChromiumVersions = ["1134"]; # https://github.com/microsoft/playwright/blob/v1.47.1/packages/playwright-core/browsers.json
in {
  home.activation.createChromiumSymlinks = lib.hm.dag.entryAfter ["writeBoundary"] ''
    #!${pkgs.runtimeShell}
    rm -rf ${dstBrowsersPath}
    mkdir -p ${dstBrowsersPath}

    srcVersion=$(ls ${srcBrowsersPath} | grep chromium- | sed 's/chromium-//')

    for version in ${lib.concatStringsSep " " dstChromiumVersions}; do
      ln -sf ${srcBrowsersPath}/chromium-$srcVersion ${dstBrowsersPath}/chromium-$version
    done
  '';
  home.sessionVariables = {
    PLAYWRIGHT_BROWSERS_PATH = dstBrowsersPath;
    PLAYWRIGHT_SKIP_VALIDATE_HOST_REQUIREMENTS = "true";
  };
}
