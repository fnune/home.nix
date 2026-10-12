#!/usr/bin/env bash

set -euo pipefail

[ $# -eq 2 ] || {
  echo "usage: $0 <disk> <disk>" >&2
  exit 1
}
disks=("$1" "$2")
hostname=earendil
mirror=https://geo.mirror.pkgbuild.com
bootstrap=/tmp/arch-bootstrap
target=/mnt/earendil

uefi() { [ -d /sys/firmware/efi ]; }
partition_of() { [[ $1 == *nvme* ]] && echo "${1}p$2" || echo "$1$2"; }

install_rescue_tools() {
  command -v apt-get >/dev/null || return 0
  DEBIAN_FRONTEND=noninteractive apt-get install -y -qq gdisk mdadm parted dosfstools zstd curl >/dev/null
}

wipe_disks() {
  mdadm --stop --scan || true
  for disk in "${disks[@]}"; do
    for partition in "$disk"?*; do
      [ -b "$partition" ] || continue
      mdadm --zero-superblock "$partition" 2>/dev/null || true
      wipefs --all --force "$partition"
    done
    wipefs --all --force "$disk"
    sgdisk --zap-all "$disk"
  done
}

partition_disks() {
  local boot_type
  if uefi; then boot_type=EF00; else boot_type=EF02; fi
  for disk in "${disks[@]}"; do
    if uefi; then
      sgdisk --new=1:0:+512M --typecode=1:$boot_type --new=2:0:0 --typecode=2:FD00 "$disk"
    else
      sgdisk --new=1:0:+1M --typecode=1:$boot_type --new=2:0:0 --typecode=2:FD00 "$disk"
    fi
  done
  partprobe "${disks[@]}"
  udevadm settle

  if uefi; then
    mdadm --create /dev/md/efi --run --level=1 --raid-devices=2 --metadata=1.0 \
      "$(partition_of "${disks[0]}" 1)" "$(partition_of "${disks[1]}" 1)"
    mkfs.fat -F 32 /dev/md/efi
  fi
  mdadm --create /dev/md/root --run --level=1 --raid-devices=2 \
    "$(partition_of "${disks[0]}" 2)" "$(partition_of "${disks[1]}" 2)"
  mkfs.ext4 -q -F -L root /dev/md/root

  mkdir -p "$target"
  mount /dev/md/root "$target"
  if uefi; then
    mkdir -p "$target/boot/efi"
    mount /dev/md/efi "$target/boot/efi"
  fi
}

prepare_bootstrap() {
  local tarball=archlinux-bootstrap-x86_64.tar.zst
  rm -rf "$bootstrap" && mkdir -p "$bootstrap"
  curl -fsSL -o "/tmp/$tarball" "$mirror/iso/latest/$tarball"
  (cd /tmp && curl -fsSL "$mirror/iso/latest/sha256sums.txt" | grep " $tarball\$" | sha256sum -c -)
  tar -xf "/tmp/$tarball" -C "$bootstrap" --strip-components=1 --numeric-owner
  echo "Server = $mirror/\$repo/os/\$arch" >"$bootstrap/etc/pacman.d/mirrorlist"
  mount --bind "$bootstrap" "$bootstrap"
  mount --rbind "$target" "$bootstrap/mnt"
}

in_bootstrap() { "$bootstrap/bin/arch-chroot" "$bootstrap" "$@"; }
in_target() { in_bootstrap arch-chroot /mnt "$@"; }

install_system() {
  local efi_packages=()
  if uefi; then efi_packages=(efibootmgr dosfstools); fi

  in_bootstrap pacman-key --init
  in_bootstrap pacman-key --populate archlinux
  in_bootstrap pacstrap -K /mnt base linux linux-firmware amd-ucode intel-ucode mdadm grub \
    openssh sudo zsh git base-devel "${efi_packages[@]}"
  in_bootstrap sh -c 'genfstab -U /mnt >>/mnt/etc/fstab'
  cp "$bootstrap/etc/pacman.d/mirrorlist" "$target/etc/pacman.d/mirrorlist"

  mdadm --detail --scan >>"$target/etc/mdadm.conf"
  sed -i 's/^\(HOOKS=.*block\)/\1 mdadm_udev/' "$target/etc/mkinitcpio.conf"
  in_target mkinitcpio -P

  echo "$hostname" >"$target/etc/hostname"
  ln -sf /usr/share/zoneinfo/UTC "$target/etc/localtime"
  sed -i 's/^#en_US.UTF-8/en_US.UTF-8/' "$target/etc/locale.gen"
  in_target locale-gen
  echo LANG=en_US.UTF-8 >"$target/etc/locale.conf"

  install -d -m 700 "$target/root/.ssh"
  install -m 600 /root/.ssh/authorized_keys "$target/root/.ssh/authorized_keys"
}

upstream_nameserver() {
  local file server
  for file in /run/systemd/resolve/resolv.conf /etc/resolv.conf; do
    [ -f "$file" ] || continue
    server=$(awk '/^nameserver/ && $2 !~ /^127\./ {print $2; exit}' "$file")
    if [ -n "$server" ]; then
      echo "$server"
      return
    fi
  done
  echo "no upstream nameserver found" >&2
  return 1
}

copy_rescue_network() {
  local interface address gateway mac nameserver
  interface=$(ip -4 route show default | awk '{print $5; exit}')
  gateway=$(ip -4 route show default | awk '{print $3; exit}')
  address=$(ip -4 -o address show dev "$interface" | awk '{print $4; exit}')
  mac=$(cat "/sys/class/net/$interface/address")
  nameserver=$(upstream_nameserver)

  cat >"$target/etc/systemd/network/20-uplink.network" <<EOF
[Match]
MACAddress=$mac

[Network]
Address=$address
Gateway=$gateway
DNS=$nameserver
EOF
  ln -sf /run/systemd/resolve/stub-resolv.conf "$target/etc/resolv.conf"
  in_target systemctl enable systemd-networkd systemd-resolved sshd
}

install_bootloader() {
  if uefi; then
    in_target grub-install --target=x86_64-efi --efi-directory=/boot/efi --removable
  else
    for disk in "${disks[@]}"; do in_target grub-install --target=i386-pc "$disk"; done
  fi
  in_target grub-mkconfig -o /boot/grub/grub.cfg
}

unmount_all() {
  umount -R "$bootstrap/mnt"
  umount "$bootstrap"
  umount -R "$target"
}

install_rescue_tools
wipe_disks
partition_disks
prepare_bootstrap
install_system
copy_rescue_network
install_bootloader
unmount_all
echo "Installed. Set the server to boot from its disks, then reboot."
