# `home.nix`

For the headless server, see [`docs/earendil.md`](docs/earendil.md).

## Setting up a new CachyOS machine

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
```

### Apply Home Manager configuration

From the `~/.home.nix` directory, run the Home Manager version pinned in `flake.lock`:

```bash
nix run . -- switch --flake . -b backup
```

`-b backup` renames dotfiles that already exist instead of failing on them. On a desktop this downloads over 20GB of packages.

To switch later, run `./switch.sh`. It applies this host's system configuration from `systems/` with [system-manager](https://github.com/numtide/system-manager), then switches Home Manager with `nh`. `./update.sh` updates the inputs and then runs it.

### Set up locales

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

### Install system packages

Home Manager installs everything else. These come from pacman because they integrate with Plasma, need system libraries, or build system packages:

```sh
sudo pacman -S --needed base-devel steam
sudo pacman -S --needed isoimagewriter kalk kate kcharselect kclock kcolorchooser keepsecret ksshaskpass kweather markdownpart partitionmanager
```

`ksshaskpass` must stay at `/usr/bin/ksshaskpass`: the Plasma SSH agent config points there.

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
