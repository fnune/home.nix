{
  config,
  pkgs,
  lib,
  ...
}: let
  dstBrowsersPath = "${config.home.homeDirectory}/.local/share/playwright";
  srcBrowsersPath = pkgs.unstable.playwright-driver.browsers;
  dstChromiumVersions = ["1124"]; # https://github.com/microsoft/playwright/blob/v1.41.2/packages/playwright-core/browsers.json
in {
  home.activation.createChromiumSymlinks = lib.hm.dag.entryAfter ["writeBoundary"] ''
    #!${pkgs.runtimeShell}
    rm -rf ${dstBrowsersPath}
    mkdir -p ${dstBrowsersPath}

    srcVersion=$(ls ${srcBrowsersPath} | grep chromium- | sed 's/chromium-//')

    for version in ${lib.concatStringsSep " " dstChromiumVersions}; do
      if [[ "$version" == "$srcVersion" ]]; then
        echo -e "\033[33mPlaywright: chromium-$version is the source version. Consider removing it from 'dstChromiumVersions'."
      else
        ln -sf ${srcBrowsersPath}/chromium-$srcVersion ${dstBrowsersPath}/chromium-$version
      fi
    done
  '';
  home.sessionVariables = {
    PLAYWRIGHT_BROWSERS_PATH = dstBrowsersPath;
    PLAYWRIGHT_SKIP_VALIDATE_HOST_REQUIREMENTS = "true";
  };
}
