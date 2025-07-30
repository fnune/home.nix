#!/usr/bin/env bash

set -euo pipefail

readonly USERNAME="fausto"
readonly REPO_URL="https://github.com/fnune/home.nix"
readonly CONFIG_DIR="${HOME}/.home.nix"

CLEANUP_TASKS=()
TEMP_PACKAGES=()

cleanup() {
  echo "Cleaning up..."

  if [[ ${#TEMP_PACKAGES[@]} -gt 0 ]]; then
    echo "Removing temporary packages: ${TEMP_PACKAGES[*]}"
    sudo apt remove -y "${TEMP_PACKAGES[@]}" || true
  fi

  local task
  for task in "${CLEANUP_TASKS[@]}"; do
    echo "Running cleanup: ${task}"
    eval "${task}" || true
  done
}

trap cleanup EXIT

check_user() {
  if [[ "${USER}" != "${USERNAME}" ]]; then
    echo "This script should be run as user ${USERNAME}" >&2
    exit 1
  fi
}

setup_sudo_access() {
  echo "Setting up sudo access for ${USERNAME}..."
  if ! groups | grep -q sudo; then
    echo "Adding ${USERNAME} to sudo group (requires root password)..."
    su - -c "usermod -aG sudo ${USERNAME}"
    echo "Refreshing group membership..."
    exec sg sudo -c "$0 $*"
  else
    echo "User ${USERNAME} already has sudo access"
  fi
}

install_nix() {
  echo "Installing Nix package manager..."

  if ! command -v nix &>/dev/null; then
    sudo apt install -y curl git
    TEMP_PACKAGES+=(curl git)

    sh <(curl --proto '=https' --tlsv1.2 -L https://nixos.org/nix/install) --daemon
    CLEANUP_TASKS+=("echo 'To uninstall Nix, run: sudo rm -rf /etc/nix /nix ~root/.nix-* ~/.nix-*'")

    echo "Loading Nix environment..."
    if [[ -f /etc/profile.d/nix.sh ]]; then
      # shellcheck source=/dev/null
      source /etc/profile.d/nix.sh
    elif [[ -f ~/.nix-profile/etc/profile.d/nix.sh ]]; then
      # shellcheck source=/dev/null
      source ~/.nix-profile/etc/profile.d/nix.sh
    else
      echo "Warning: Could not find Nix profile script"
    fi

    export PATH="/nix/var/nix/profiles/default/bin:${PATH}"
  else
    echo "Nix is already installed"
  fi
}

setup_nix_config() {
  echo "Setting up Nix configuration..."

  if ! grep -q "experimental-features" /etc/nix/nix.conf 2>/dev/null; then
    if [[ -f /etc/nix/nix.conf ]]; then
      sudo cp /etc/nix/nix.conf /etc/nix/nix.conf.bak
      CLEANUP_TASKS+=("sudo mv /etc/nix/nix.conf.bak /etc/nix/nix.conf 2>/dev/null || true")
    fi

    echo "experimental-features = nix-command flakes" | sudo tee -a /etc/nix/nix.conf
    sudo systemctl restart nix-daemon
    sleep 2
  else
    echo "Nix experimental features already enabled"
  fi
}

clone_config() {
  echo "Cloning configuration repository..."

  if [[ ! -d "${CONFIG_DIR}" ]]; then
    nix-shell -p git curl --run "git clone ${REPO_URL} ${CONFIG_DIR}"
    cd "${CONFIG_DIR}"
    git checkout debian
  else
    echo "Configuration repository already exists at ${CONFIG_DIR}"
    cd "${CONFIG_DIR}"
    git fetch origin
    git checkout debian
    git pull origin debian
  fi
}

setup_plymouth() {
  echo "Setting up Plymouth boot splash..."

  sudo apt install -y plymouth plymouth-themes

  local current_theme
  current_theme=$(sudo plymouth-set-default-theme)
  if [[ "${current_theme}" != "spinner" ]]; then
    CLEANUP_TASKS+=("sudo plymouth-set-default-theme ${current_theme}; sudo update-initramfs -u")

    sudo plymouth-set-default-theme spinner
    sudo update-initramfs -u
  else
    echo "Plymouth spinner theme already set"
  fi

  if ! grep -q "splash" /etc/default/grub; then
    sudo cp /etc/default/grub /etc/default/grub.bak
    CLEANUP_TASKS+=("sudo mv /etc/default/grub.bak /etc/default/grub; sudo update-grub")

    sudo sed -i 's/GRUB_CMDLINE_LINUX_DEFAULT="[^"]*/& splash/' /etc/default/grub
    sudo update-grub
  else
    echo "GRUB splash already configured"
  fi
}

apply_home_config() {
  echo "Applying Home Manager configuration..."
  cd "${CONFIG_DIR}"

  nix run home-manager/release-25.05 -- switch --flake "."

  echo "Note: This downloads about 23GB of packages"
}

setup_locales() {
  echo "Setting up locales..."

  sudo apt install -y locales

  local locale_exists=false
  if grep -q "en_US.UTF-8 UTF-8" /etc/locale.gen &&
    grep -q "en_DK.UTF-8 UTF-8" /etc/locale.gen &&
    grep -q "en_GB.UTF-8 UTF-8" /etc/locale.gen &&
    grep -q "de_DE.UTF-8 UTF-8" /etc/locale.gen; then
    locale_exists=true
  fi

  if [[ "${locale_exists}" == "false" ]]; then
    sudo cp /etc/locale.gen /etc/locale.gen.bak 2>/dev/null || true
    CLEANUP_TASKS+=("sudo mv /etc/locale.gen.bak /etc/locale.gen 2>/dev/null || true")

    cat <<'EOF' | sudo tee -a /etc/locale.gen
en_US.UTF-8 UTF-8
en_DK.UTF-8 UTF-8
en_GB.UTF-8 UTF-8
de_DE.UTF-8 UTF-8
EOF
    sudo locale-gen
  else
    echo "Locales already configured"
  fi

  if [[ ! -f /etc/default/locale ]] || ! grep -q 'LANG="en_US.UTF-8"' /etc/default/locale; then
    [[ -f /etc/default/locale ]] && sudo cp /etc/default/locale /etc/default/locale.bak
    CLEANUP_TASKS+=("sudo mv /etc/default/locale.bak /etc/default/locale 2>/dev/null || true")

    sudo tee /etc/default/locale <<'EOF'
LANG="en_US.UTF-8"
LANGUAGE="en_US:en"
LC_CTYPE="en_US.UTF-8"
LC_MESSAGES="en_US.UTF-8"
LC_IDENTIFICATION="en_US.UTF-8"
LC_COLLATE="en_US.UTF-8"
LC_MEASUREMENT="en_DK.UTF-8"
LC_TIME="en_GB.UTF-8"
LC_ADDRESS="de_DE.UTF-8"
LC_MONETARY="de_DE.UTF-8"
LC_NAME="de_DE.UTF-8"
LC_NUMERIC="de_DE.UTF-8"
LC_PAPER="de_DE.UTF-8"
LC_TELEPHONE="de_DE.UTF-8"
EOF
    sudo update-locale
  else
    echo "Locale defaults already configured"
  fi
}

setup_ssh_kde_wallet() {
  echo "Setting up SSH with KDE Wallet integration..."

  mkdir -p ~/.config/environment.d

  if [[ ! -f ~/.config/environment.d/ssh_askpass.conf ]] || ! grep -q "SSH_ASKPASS=/usr/bin/ksshaskpass" ~/.config/environment.d/ssh_askpass.conf; then
    cat >~/.config/environment.d/ssh_askpass.conf <<'EOF'
SSH_ASKPASS=/usr/bin/ksshaskpass
SSH_ASKPASS_REQUIRE=prefer
EOF
    echo "Created SSH askpass configuration for KDE Wallet integration"
  else
    echo "SSH askpass already configured for KDE Wallet"
  fi
}

final_notes() {
  echo ""
  echo "Bootstrap complete! Additional steps:"
  echo "1. Go to Settings -> Login Screen -> Apply Plasma Settings"
  echo "2. Consider rebooting for best results (locales, group membership, plymouth theme)"
}

main() {
  echo "Debian Bootstrap Script for ${USERNAME}"
  echo "====================================="

  check_user
  setup_sudo_access "$@"
  install_nix
  setup_nix_config
  clone_config
  setup_locales
  setup_plymouth
  setup_ssh_kde_wallet
  apply_home_config
  final_notes
}

main "$@"
