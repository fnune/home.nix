# `home.nix`

## Setting up a new CachyOS machine

### Initial setup

Add user to sudo group if needed:

```bash
su - -c "usermod -aG sudo $USER"
```

### Install Nix

Install dependencies and Nix package manager:

```bash
sudo pacman -S curl git
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

Ensure `splash` is in `GRUB_CMDLINE_LINUX_DEFAULT` in `/etc/default/grub`, then:

```bash
sudo grub-mkconfig -o /boot/grub/grub.cfg
```

### Configure KDE Wallet for SSH

KWallet integration is automatic with KDE. If some program uses GNOME Keyring instead, mask it:

```sh
systemctl --user mask gnome-keyring-daemon.service
systemctl --user mask gnome-keyring-daemon.socket
```

### Set up SDDM

Go to Settings → Login Screen → Apply Plasma Settings. Then, create `/etc/sddm.conf.d/hidpi.conf`:

```ini
[General]
GreeterEnvironment=QT_SCREEN_SCALE_FACTORS=1.6

[Wayland]
EnableHiDPI=true

[X11]
EnableHiDPI=true
```

Apply modifications to the theme you're using, e.g. by creating `/usr/share/sddm/themes/breeze/theme.conf.user`:

```ini
[General]
type=color
color=#212121
background=
```

### Fix Flatpak permissions

To make Flatpaks work more seamlessly with the host system:

```sh
flatpak override --user --talk-name=org.freedesktop.portal.Desktop
flatpak override --user --talk-name=org.freedesktop.portal.Settings

flatpak override --user --filesystem=/nix/store/:ro

flatpak override --user --filesystem=xdg-config/fontconfig:ro
flatpak override --user --filesystem=/home/$USER/.icons/:ro
flatpak override --user --filesystem=/usr/share/icons/:ro
```

### Tuxedo InfinityBook hardware setup

For the Tuxedo InfinityBook Pro 14 Gen9, additional setup is required:

#### Disable secure boot

The ethernet driver requires secure boot to be disabled in BIOS/UEFI.

#### Add kernel parameter

Add to `/etc/default/grub`:

```bash
GRUB_CMDLINE_LINUX_DEFAULT="quiet acpi.ec_no_wakeup=1"
```

Update GRUB:

```bash
sudo grub-mkconfig -o /boot/grub/grub.cfg
```

#### Install ethernet driver

```bash
sudo pacman -S linux-cachyos-headers
paru -S yt6801-dkms
```

Verify:

```bash
dkms status
ip link show
```

#### Reboot

```bash
sudo reboot
```

After reboot, verify everything works:

```bash
cat /proc/cmdline | grep acpi.ec_no_wakeup
ip link show
ping -c 4 1.1.1.1
```
