# Moving pacman programs to nixpkgs

Plan for replacing the GUI programs in `services.pacman.packages` with nixpkgs builds, validated one by one. Trials ran on 2026-10-16 and 2026-10-18; results are below.

## What moves and what stays

Move standalone apps that bring their whole stack with them and only talk to the desktop over D-Bus or portals. Keep on pacman anything that loads the host's plugins, registers system pieces (udev rules, polkit or KAuth helpers, capabilities, services), or needs 32-bit libraries.

Stays on pacman:

- KDE apps (haruna, isoimagewriter, kalk, kate, markdownpart, kcharselect, kclock, kcolorchooser, kdenlive, ksshaskpass, kweather, partitionmanager): a Nix build brings its own Qt and KDE Frameworks, so it can't load the host's Breeze style, Plasma file dialogs, kio-extras workers or KParts, and the root helpers need polkit registration in `/usr/share`.
- base-devel and the Playwright Chromium libraries: binaries built or downloaded outside Nix link against them.
- Fonts: the pacman apps and Plasma read them from the system fontconfig.
- flatpak and flatpak-kcm: a system service.
- solaar: its udev rules for Logitech receivers ship in the pacman package.
- wireshark-qt and tcpdump: capture relies on the capabilities and the `wireshark` group the pacman packages set up.
- steam: needs 32-bit drivers.
- keepsecret: not in nixpkgs.

Moved to nixpkgs on 2026-10-18: kitty, firefox, thunderbird, bitwarden, bitwarden-cli, obsidian, darktable, krita, obs-studio, signal-desktop, chromium, calibre, libreoffice-qt, pdfarranger, podman-desktop, godot, reaper (as `reaper.override { jackLibrary = pipewire.jack; }`, with JACK selected in its audio preferences).

## How to trial

1. Add a `modules/apps/nixpkgs-trial.nix` that puts the candidates from `pkgs-unstable` in `home.packages`, and import it from `modules/apps/default.nix`.
2. Back up each program's profile before its first launch from Nix: some upgrade their profile so the older pacman build refuses it afterwards.
3. Launch from a terminal. `PATH` has `~/.nix-profile/bin` first, but the Plasma menu and KRunner still launch the pacman copy, because `XDG_DATA_DIRS` lists `/usr/share` before `~/.nix-profile/share`. Check with `readlink /proc/$(pgrep -n <name>)/exe`.
4. Once a program works, move it to its own module and drop it from `services.pacman.packages`: the next activation uninstalls it.

## Gotchas

- Firefox and Thunderbird: the nixpkgs wrappers set `MOZ_LEGACY_PROFILES=1`, so they open the profile with `Default=1` in `profiles.ini` instead of the one in `installs.ini`. Both `profiles.ini` files were already switched to the real profiles (`t1n66puz.default-release` and `syputyvj.default-release`), so this is done on this machine; a fresh setup needs the same flip.
- Thunderbird: `~/.config/mimeapps.list` pointed mailto and message types at `userapp-Thunderbird-*.desktop`, which ran `/usr/lib/thunderbird/thunderbird`. They now point at `thunderbird.desktop`; the old files are in `~/.local/share/applications.bak-2026-10-18`.
- Desktop IDs differ (`org.mozilla.Thunderbird` vs `thunderbird`, `md.obsidian.Obsidian` vs `obsidian`), so KRunner shows duplicates while both are installed, and the Nix entries show without categories. Goes away once the pacman copy is removed.
- Reaper: ALSA fails, because Nix's alsa-lib can't read Arch's pipewire-alsa config. Build it with `reaper.override { jackLibrary = pipewire.jack; }` and select JACK: it then talks to the host's PipeWire directly. The pacman Reaper fails with JACK selected, since Arch has jack2 and no JACK server runs, so switch back to PulseAudio if you go back to it.
- Backups: `~/.mozilla/firefox.bak-2026-10-16`, `~/.thunderbird.bak-2026-10-16`, `~/.config/darktable.bak-2026-10-16`, `~/.config/Signal.bak-2026-10-18`, `~/.config/chromium.bak-2026-10-18`, `~/.config/mimeapps.list.bak-2026-10-18`. Delete once happy.
- Firefox and Thunderbird policies come from their Nix wrappers (`extraPolicies`). `/etc/firefox/policies` is left over from `install-browser-policies` and can go.

## Status

| Program | Status | Notes |
| --- | --- | --- |
| kitty | Works | |
| firefox | Works | After the `profiles.ini` flip |
| thunderbird | Works | After the `profiles.ini` flip; repoint mimeapps |
| bitwarden | Works | |
| bitwarden-cli | Works | |
| obsidian | Works | |
| darktable | Works | Backup first |
| krita | Works | |
| obs-studio | Works | |
| reaper | Works | With the PipeWire JACK override and JACK selected |
| chromium | Works | Upgrades the profile: back up first |
| calibre | Works | |
| libreoffice-qt | Works | |
| pdfarranger | Works | |
| podman-desktop | Works | |
| godot | Works | |
| signal-desktop | Works | Opened pacman 8.31's database with nixpkgs 8.29 |
| steam | Held back | Needs 32-bit drivers at `/run/opengl-driver-32` |
| keepsecret | Stays | Not in nixpkgs |
