{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.services.apt;

  packageList = unique cfg.packages;

  checkAndInstallScript = pkgs.writeShellScript "apt-install-missing" ''
    if ! command -v /usr/bin/apt >/dev/null 2>&1; then
      echo "apt not found, skipping package installation"
      exit 0
    fi

    packages_to_install=()

    for package in ${concatStringsSep " " (map (pkg: "'${pkg}'") packageList)}; do
      if /usr/bin/dpkg -l "$package" >/dev/null 2>&1; then
        echo "Package $package is already installed"
      else
        echo "Package $package is missing, will install"
        packages_to_install+=("$package")
      fi
    done

    if [ ''${#packages_to_install[@]} -gt 0 ]; then
      echo "Installing missing packages via apt: ''${packages_to_install[*]}"
      /usr/bin/sudo /usr/bin/apt install -y "''${packages_to_install[@]}"
    fi
  '';
in {
  options.services.apt = {
    enable = mkEnableOption "apt package management";

    packages = mkOption {
      type = types.listOf types.str;
      default = [];
      description = "List of apt packages to install";
      example = ["curl" "git" "vim"];
    };
  };

  config = mkIf cfg.enable {
    home.activation.aptPackages = lib.hm.dag.entryAfter ["writeBoundary"] ''
      ${checkAndInstallScript}
    '';
  };
}
