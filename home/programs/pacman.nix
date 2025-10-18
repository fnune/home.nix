{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.services.pacman;

  packageList = unique cfg.packages;

  checkAndInstallScript = pkgs.writeShellScript "pacman-install-missing" ''
    if ! command -v /usr/bin/pacman >/dev/null 2>&1; then
      echo "pacman not found, skipping package installation"
      exit 0
    fi

    packages_to_install=()

    for package in ${concatStringsSep " " (map (pkg: "'${pkg}'") packageList)}; do
      if ! /usr/bin/pacman -Qi "$package" >/dev/null 2>&1; then
        packages_to_install+=("$package")
      fi
    done

    if [ ''${#packages_to_install[@]} -gt 0 ]; then
      echo "Installing missing packages via pacman: ''${packages_to_install[*]}"
      /usr/bin/sudo /usr/bin/pacman -S --noconfirm "''${packages_to_install[@]}"
    else
      echo "All packages already installed"
    fi
  '';
in {
  options.services.pacman = {
    enable = mkEnableOption "pacman package management";

    packages = mkOption {
      type = types.listOf types.str;
      default = [];
      description = "List of pacman packages to install";
      example = ["curl" "git" "vim"];
    };
  };

  config = mkIf cfg.enable {
    home.activation.pacmanPackages = lib.hm.dag.entryAfter ["writeBoundary"] ''
      ${checkAndInstallScript}
    '';
  };
}
