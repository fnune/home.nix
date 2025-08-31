# `home.nix`

## Setting up a new Debian machine

### Initial setup

Add user to sudo group if needed:

```bash
su - -c "usermod -aG sudo $USER"
```

### Install Nix

Install dependencies and Nix package manager:

```bash
sudo apt install -y curl git
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
git checkout debian
```

### Apply Home Manager configuration

From the `~/.home.nix` directory:

```bash
nix run home-manager/release-25.05 -- switch --flake "."
```

This downloads over 20GB of packages.

### Set up locales

Install locales package:

```bash
sudo apt install -y locales
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

Configure `/etc/default/locale`:

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

Install Plymouth:

```bash
sudo apt install -y plymouth plymouth-themes
sudo plymouth-set-default-theme spinner
sudo update-initramfs -u
```

Add `splash` to `GRUB_CMDLINE_LINUX_DEFAULT` in `/etc/default/grub`, then:

```bash
sudo update-grub
```

Set `pinentry-kwallet` as the priority `pinentry` alternative:

```sh
sudo update-alternatives --install /usr/bin/pinentry pinentry /usr/bin/pinentry-kwallet 95
```

If some program continues to use GNOME Keyring (which may be installed by programs unrelated to KDE) then mask the service:

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

Apply modifications to the theme you're using, e.g. by creating `/usr/share/sddm/themes/debian-breeze/theme.conf.user`:

```ini
[General]
type=color
color=#212121
background=
```

### Fix Flatpak permissions

To make Flatpaks work more seamlessly with the host system:

```sh
# Enable Flatpaks to see e.g. whether the system is using light or dark mode
flatpak override --user --talk-name=org.freedesktop.portal.Desktop
flatpak override --user --talk-name=org.freedesktop.portal.Settings

# Let Flatpaks read the Nix store to e.g. allow access to fonts and cursors
flatpak override --user --filesystem=/nix/store/:ro

# Also host system fonts and cursors
flatpak override --user --filesystem=xdg-config/fontconfig:ro
flatpak override --user --filesystem=/home/$USER/.icons/:ro
flatpak override --user --filesystem=/usr/share/icons/:ro
```

## Enable external repositories

Enables installing e.g. Docker and a more up-to-date Firefox.

```sh
sudo extrepo enable mozilla
sudo extrepo enable docker-ce
```
