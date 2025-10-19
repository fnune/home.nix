# `home.nix`

## Setting up a new CachyOS machine

### Initial setup

Add user to sudo group if needed:

```bash
su - -c "usermod -aG sudo $USER"
```

### Install Nix

Install the Nix package manager:

```bash
sh <(curl --proto '=https' --tlsv1.2 -L https://nixos.org/nix/install) --daemon
```

Enable experimental features by adding to `/etc/nix/nix.conf`:

```bash
experimental-features = nix-command flakes
```

### Get configuration

Clone the home.nix repository:

```bash
git clone https://github.com/fnune/home.nix ~/.home.nix
cd ~/.home.nix
git checkout arch
```

### Apply Home Manager configuration

From the `~/.home.nix` directory:

```bash
nix run home-manager/release-25.05 -- switch --flake "."
```

This downloads over 20GB of packages.

To switch later, you can use `nh`:

```sh
nh home switch .
```

### Set up locales

Install locales package:

```bash
sudo pacman -S glibc
```

Add these locales to `/etc/locale.gen`:

```bash
en_US.UTF-8 UTF-8
en_DK.UTF-8 UTF-8
en_GB.UTF-8 UTF-8
de_DE.UTF-8 UTF-8
```

Generate locales:

```bash
sudo locale-gen
```

Configure `/etc/locale.conf`:

```bash
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
```

### Configure boot splash

Plymouth is pre-installed in CachyOS. Configure theme:

```bash
sudo plymouth-set-default-theme spinner
sudo mkinitcpio -P
```

### Fix some Flatpaks

To make Flatpaks work more seamlessly with the host system:

```sh
flatpak override --user com.slack.Slack --socket=wayland --env=ELECTRON_OZONE_PLATFORM_HINT=auto
```

### Install browser policies

Install system-wide browser policies for Firefox and Chromium:

```sh
install-browser-policies
```

This installs:

- Firefox policies to `/etc/firefox/policies/policies.json`
- Chromium policies to `/etc/chromium/policies/managed/policies.json`

Restart browsers and verify at `about:policies` (Firefox) or `chrome://policy` (Chromium).

### Tuxedo InfinityBook hardware setup

For the Tuxedo InfinityBook Pro 14 Gen9, additional setup is required:

#### Disable secure boot

The ethernet driver requires secure boot to be disabled in BIOS/UEFI.

#### Add kernel parameter

Edit your boot entry file:

```bash
sudoedit /boot/loader/entries/linux-cachyos.conf
```

Add the parameter to the `options` line:

```bash
options root=UUID=<redacted> quiet acpi.ec_no_wakeup=1
```

#### Install ethernet driver

```bash
sudo pacman -S linux-cachyos-headers
paru -S yt6801-dkms
```
