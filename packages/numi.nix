{
  lib,
  stdenv,
  fetchurl,
  autoPatchelfHook,
  openssl,
  gcc-unwrapped,
}: let
  version = "0.13.0";

  sources = {
    x86_64-linux = {
      url = "https://github.com/nikolaeu/numi/releases/download/cli-v${version}/numi-cli-v${version}-x86_64-unknown-linux-gnu.tar.gz";
      sha256 = "sha256-W/y3ncNYuoXg5J8qR78+yCXNfzPxGFkEDl88uX8qv68";
    };

    aarch64-linux = {
      url = "https://github.com/nikolaeu/numi/releases/download/cli-v${version}/numi-cli-v${version}-aarch64-unknown-linux-gnu.tar.gz";
      sha256 = "sha256-B3PwfMYKPxR7AQFxzm9X5PjgyQUmONHhnnGTYrnndJE=";
    };
  };

  source = sources.${stdenv.hostPlatform.system} or (throw "Unsupported system: ${stdenv.hostPlatform.system}");
in
  stdenv.mkDerivation {
    pname = "numi-cli";
    inherit version;

    src = fetchurl {
      inherit (source) url sha256;
    };

    meta = with lib; {
      description = "Numi CLI - beautiful calculator for the terminal";
      homepage = "https://github.com/nikolaeu/numi";
      license = licenses.unfree;
      maintainers = with maintainers; [fnune];
      platforms = ["x86_64-linux" "aarch64-linux"];
      sourceProvenance = with sourceTypes; [binaryNativeCode];
      mainProgram = "numi-cli";
    };

    nativeBuildInputs = [autoPatchelfHook];
    buildInputs = [openssl gcc-unwrapped];
    sourceRoot = ".";
    installPhase = ''
      runHook preInstall
      install -Dm755 numi-cli $out/bin/numi-cli
      runHook postInstall
    '';
  }
