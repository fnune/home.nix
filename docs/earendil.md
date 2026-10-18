# Earendil

Earendil is a rented, always-on Arch Linux server for long-running coding agents and development work. It runs the `fausto@earendil` Home Manager configuration, a headless subset of the desktop one: shell, editor, version control, containers and agents, but no desktop or GUI apps.

These steps were tested in a local VM built from the Arch cloud image (see [Test in a VM](#test-in-a-vm)), but not yet on a real server. Fix them as you go.

## Install Arch Linux

Earendil is an OVHcloud Eco dedicated server. OVHcloud has no Arch template, so [`earendil-install.sh`](earendil-install.sh) installs Arch from OVHcloud's rescue system: RAID1 across both drives, a minimal Arch from the official bootstrap image, and GRUB on both drives. It never changes the firmware's boot order, because rescue mode depends on the server trying the network first.

1. In the OVHcloud control panel, add your SSH public key, then set the server to boot into rescue mode with that key and restart it.
2. `ssh root@<server-ip>` and check the hardware:

    ```sh
    ls /dev/tpmrm0 # must exist
    lsblk # the two drives for the install script
    ```

    The box needs a TPM 2.0: credentials are sealed with it, and nothing else protects them without someone at a desktop to unlock a keyring. If `/dev/tpmrm0` is missing, ask OVHcloud support for a remote console (IPMI) and enable the TPM (fTPM on AMD, PTT on Intel) in the firmware.

3. From your machine, `scp docs/earendil-install.sh root@<server-ip>:`, then in the rescue system run it with the two drives `lsblk` showed. It wipes both:

    ```sh
    bash earendil-install.sh /dev/nvme0n1 /dev/nvme1n1
    ```

4. In the control panel, set the server to boot from its disks again, and restart it.

The script sets the hostname, copies the rescue system's network settings, and gives root your key. Then, as root:

```sh
pacman -Syu --needed base-devel git openssh sudo zsh
pacman -S --needed alsa-lib at-spi2-core libx11 libxcb libxcomposite libxdamage libxext libxfixes libxkbcommon libxrandr mesa nspr nss noto-fonts noto-fonts-cjk noto-fonts-emoji ttf-dejavu ttf-liberation # for the Chromium that Playwright downloads
useradd --create-home --groups wheel,tss --shell /usr/bin/zsh fausto # tss grants /dev/tpmrm0
passwd fausto
EDITOR=nano visudo # uncomment the %wheel line
```

Reboot now. The upgrade usually replaces the kernel, and until a reboot the running one cannot load modules, which breaks the firewall below with `Could not fetch rule set generation id`.

Rootless Podman needs subordinate IDs. `useradd` normally adds them. Check that `/etc/subuid` and `/etc/subgid` both have a `fausto` line, and add them if not:

```sh
usermod --add-subuids 100000-165535 --add-subgids 100000-165535 fausto
```

Set up locales as in the [README](../README.md#set-up-locales).

## Lock down SSH

Give `fausto` root's authorized key:

```sh
install -d -m700 -o fausto -g fausto /home/fausto/.ssh
install -m600 -o fausto -g fausto /root/.ssh/authorized_keys /home/fausto/.ssh/authorized_keys
```

Log in as `fausto` in a new terminal to check it works, then disable passwords and root login:

```sh
sudo tee /etc/ssh/sshd_config.d/10-hardening.conf <<'EOF'
PasswordAuthentication no
KbdInteractiveAuthentication no
PermitRootLogin no
EOF
sudo systemctl restart sshd
```

Once the configuration is applied, `./switch.sh` manages this file from `systems/earendil.nix`.

## Join the tailnet

```sh
sudo pacman -S tailscale
sudo systemctl enable --now tailscaled
sudo tailscale up
```

Open the printed URL on another device to approve the machine, or skip that with a pre-approved, tagged key: `sudo tailscale up --auth-key <key>`. From your laptop, check that `ssh fausto@earendil` works over Tailscale before closing public SSH.

Then allow inbound traffic only over Tailscale:

```sh
sudo pacman -S ufw
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw allow in on tailscale0
sudo ufw allow 41641/udp # direct Tailscale connections instead of relayed ones
sudo systemctl enable --now ufw
sudo ufw enable
```

Then block public SSH in front of the box too, with OVHcloud's edge network firewall. It is stateless and IPv4-only, with at most 20 rules per address, so replies to the box's own connections need rules of their own. In priority order:

| Priority | Protocol | Port | TCP option | Action | For |
| --- | --- | --- | --- | --- | --- |
| 0 | tcp |  | established | accept | replies to the box's TCP connections |
| 1 | udp | destination 41641 |  | accept | Tailscale |
| 2 | udp | source 53 |  | accept | DNS replies |
| 3 | udp | source 123 |  | accept | NTP replies |
| 4 | udp | source 3478 |  | accept | Tailscale's NAT discovery |
| 5 | icmp |  |  | accept | ping and path MTU |
| 19 | ipv4 |  |  | deny | everything else |

While setting up, add `tcp`, destination port 22, accept, at priority 6, and remove it once SSH over Tailscale works. If the firewall ever locks you out, disable it in the control panel. IPv6 stays unfiltered here, since ufw on the box covers it.

## Keep user services running without a login

Podman's API socket, the SSH agent and terminal sessions run as systemd user services. Lingering keeps them running when nobody is logged in:

```sh
sudo loginctl enable-linger fausto
```

## Apply the Home Manager configuration

Install Nix and apply the configuration as in the [README](../README.md#install-nix), as `fausto`. Home Manager picks `fausto@earendil` from the hostname.

Packages missing from the Nix binary cache are built from source, mostly fetched from GitHub, so a GitHub outage can fail the first switch. To avoid that, build on a machine that already has most of the closure and copy it over:

```sh
nix build .#homeConfigurations.\"fausto@earendil\".activationPackage
nix copy --no-check-sigs --to 'ssh-ng://earendil?remote-program=/nix/var/nix/profiles/default/bin/nix-daemon' ./result
ssh earendil ". /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh && HOME_MANAGER_BACKUP_EXT=backup $(readlink -f result)/activate"
```

This needs `trusted-users = root fausto` in earendil's `/etc/nix/nix.conf`, followed by `sudo systemctl restart nix-daemon`, because locally built paths are unsigned. `./switch.sh` sets it from `systems/earendil.nix`; add it by hand only for the first copy. Until the configuration is applied, Nix is not on `PATH` for non-interactive SSH, hence `remote-program` and sourcing the profile.

## Log in to everything once

These keep their credentials on the box, so they are a one-off:

- [ ] `ssh-keygen -t ed25519` with a passphrase, then add `~/.ssh/id_ed25519.pub` to GitHub twice: as an authentication key and as a signing key.
- [ ] `gh auth login --with-token`, given a fine-grained token limited to the repositories you work in, with an expiry.
- [ ] `claude`, then `/login`
- [ ] Clone your agent skills into `~/.claude/skills`.

Work-specific logins and checkouts are kept outside this public repository.

## Credentials

The box holds only credentials made for it, each revocable on its own, and cannot reach your other machines:

- Tailscale: tag it `tag:server` and allow your devices to reach it, never the reverse. Keep node key expiry on.
- Mint every token for earendil alone, named after it and with an expiry. Prefer short-lived credentials issued per use over static keys.
- Seal tokens with the TPM where the tool supports it. After a reboot, `ssh-add` once to unlock the SSH key.
- Run agents with Claude Code's sandbox, denying reads of `~/.ssh`, token stores and the Chrome profile.
- Keep `fausto`'s sudo password, so agents cannot become root.
- Sign the Chrome profile in to claude.ai and the sites agents need, nothing else.
- No personal credentials here: no cloud storage, no WireGuard keys, no personal email.
- Keep a private list of what the box holds and where each item is revoked.

## Sign in to Claude in Chrome

Chrome runs on a virtual display as the `chrome` user service, so agents on earendil can use Claude in Chrome while your other machines are off. The extension is force-installed by policy, but needs one sign-in through a VNC view:

1. `./switch.sh` from the clone, then `systemctl --user restart chrome`.
2. Run `claude --chrome` once, so Claude Code registers its native messaging host, then `systemctl --user restart chrome` again so Chrome picks it up.
3. From your desktop or laptop, run `earendil-browser`. It opens a window showing earendil's Chrome, and closing the window ends the connection. Behind it, VNC travels through SSH to a socket only `fausto` can open: the display has no network port.
4. In that Chrome, sign in to the extension with the same claude.ai organization that `claude` uses (`/status` shows it).

Run `earendil-browser` again whenever an agent hands you a login page or CAPTCHA, or to watch what agents do in the browser.

## Connect

From another machine: `ssh earendil`, then `herdr` to attach to the running session.

## Test in a VM

[`earendil-vm.sh`](earendil-vm.sh) boots a local Arch VM that starts the way a fresh server does, with an emulated TPM, so you can rehearse these steps. Differences from a real box:

- SSH arrives on `eth0` through QEMU's port forward, so add `sudo ufw allow in on eth0 to any port 22 proto tcp` before enabling ufw, or you lock yourself out.
- Skip `tailscale up` unless you want the VM in your tailnet.
- To test unpushed changes, copy the working tree in instead of cloning, then `git add -A` there so the flake sees new files:

    ```sh
    tar -C ~/.home.nix --exclude=./.jj --exclude=./result -cf - . | ssh -p 2222 -i ~/.cache/earendil-vm/vm_key fausto@127.0.0.1 'mkdir -p ~/.home.nix && tar -C ~/.home.nix -xf -'
    ```
