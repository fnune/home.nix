{
  pkgs,
  version,
  src,
  ...
}: {
  memfaultd = pkgs.rustPlatform.buildRustPackage {
    pname = "memfaultd";
    cargoLock = {lockFile = "${src}/Cargo.lock";};
    inherit version;
    inherit src;
    nativeBuildInputs = with pkgs; [cmake pkg-config];
    buildInputs = with pkgs; [zlib.dev systemd.dev libconfig];

    buildNoDefaultFeatures = true;
    buildFeatures = ["collectd" "logging" "log-to-metrics" "systemd" "rust-tls"];
  };
}
