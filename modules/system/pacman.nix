{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.services.pacman;

  packageList = unique cfg.packages;

  lastDeclaredFile = "${config.xdg.stateHome}/home-manager/pacman-packages";

  syncScript = pkgs.writeShellScript "pacman-sync" ''
    if ! command -v /usr/bin/pacman >/dev/null 2>&1; then
      echo "pacman not found, skipping package installation"
      exit 0
    fi

    pacman_or_retry_next_activation() {
      /usr/bin/sudo /usr/bin/pacman "$@" || exit 0
    }

    declared=(${concatStringsSep " " (map (pkg: "'${pkg}'") packageList)})

    packages_to_install=()
    for package in "''${declared[@]}"; do
      if ! /usr/bin/pacman -Qi "$package" >/dev/null 2>&1; then
        packages_to_install+=("$package")
      fi
    done

    if [ ''${#packages_to_install[@]} -gt 0 ]; then
      echo "Installing missing packages via pacman: ''${packages_to_install[*]}"
      pacman_or_retry_next_activation -S --noconfirm "''${packages_to_install[@]}"
    else
      echo "All packages already installed"
    fi

    if [ -f "${lastDeclaredFile}" ]; then
      undeclared=()
      while IFS= read -r package; do
        if [[ " ''${declared[*]} " != *" $package "* ]] && /usr/bin/pacman -Qi "$package" >/dev/null 2>&1; then
          undeclared+=("$package")
        fi
      done < "${lastDeclaredFile}"

      if [ ''${#undeclared[@]} -gt 0 ]; then
        pacman_or_retry_next_activation -D --asdeps "''${undeclared[@]}" >/dev/null
        mapfile -t unrequired < <(/usr/bin/pacman -Qdtq "''${undeclared[@]}" 2>/dev/null)
        if [ ''${#unrequired[@]} -gt 0 ]; then
          echo "Removing packages no longer declared: ''${unrequired[*]}"
          pacman_or_retry_next_activation -Rns --noconfirm "''${unrequired[@]}"
        fi
      fi
    fi

    mkdir -p "$(dirname "${lastDeclaredFile}")"
    printf '%s\n' "''${declared[@]}" > "${lastDeclaredFile}"
  '';
in
{
  options.services.pacman = {
    enable = mkEnableOption "pacman package management";

    packages = mkOption {
      type = types.listOf types.str;
      default = [ ];
      description = "Pacman packages to install. Packages dropped from this list are removed on the next activation, unless another package still needs them.";
      example = [
        "curl"
        "git"
        "vim"
      ];
    };
  };

  config = mkIf cfg.enable {
    home.activation.pacmanPackages = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      if [[ -v DRY_RUN ]]; then
        echo "Would sync pacman packages"
      else
        ${syncScript}
      fi
    '';
  };
}
