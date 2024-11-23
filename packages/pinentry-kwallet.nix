{
  stdenv,
  kwalletcli,
}:
stdenv.mkDerivation {
  pname = "pinentry-kwallet";
  inherit (kwalletcli) version;
  phases = ["buildPhase"];
  buildPhase = ''
    mkdir -p $out/bin
    ln -s ${kwalletcli}/bin/pinentry-kwallet $out/bin/pinentry-kwallet
  '';

  # Waiting for upstream: https://github.com/NixOS/nixpkgs/pull/344299
  meta.mainProgram = "pinentry-kwallet";
}
