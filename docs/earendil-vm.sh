#!/usr/bin/env bash

set -euo pipefail

dir=${EARENDIL_VM_DIR:-$HOME/.cache/earendil-vm}
image_url=https://geo.mirror.pkgbuild.com/images/latest/Arch-Linux-x86_64-cloudimg.qcow2
port=2222

mkdir -p "$dir/image" "$dir/seed"
cd "$dir"

run_without_host_libraries() { env -u LD_LIBRARY_PATH nix shell nixpkgs#qemu_kvm nixpkgs#cdrkit nixpkgs#swtpm -c "$@"; }

if [ ! -f image/cloudimg.qcow2 ]; then
  curl -fsSL -o image/cloudimg.qcow2 "$image_url"
  echo "$(curl -fsSL "$image_url.SHA256" | cut -d' ' -f1)  image/cloudimg.qcow2" | sha256sum -c
fi

[ -f vm_key ] || ssh-keygen -q -t ed25519 -N '' -C earendil-vm -f vm_key

cat >seed/user-data <<EOF
#cloud-config
disable_root: false
ssh_pwauth: false
users:
  - name: root
    ssh_authorized_keys:
      - $(cat vm_key.pub)
EOF
printf 'instance-id: earendil-vm\nlocal-hostname: archlinux\n' >seed/meta-data

if [ ! -f disk.qcow2 ]; then
  run_without_host_libraries genisoimage -quiet -output seed.iso -volid cidata -joliet -rock seed/user-data seed/meta-data
  run_without_host_libraries qemu-img create -q -f qcow2 -F qcow2 -b image/cloudimg.qcow2 disk.qcow2 80G
fi

mkdir -p tpm
run_without_host_libraries swtpm socket --tpm2 --daemon \
  --tpmstate dir=tpm --ctrl type=unixio,path=tpm/swtpm.sock --pid file=tpm/swtpm.pid

run_without_host_libraries qemu-system-x86_64 -enable-kvm -cpu host -smp 8 -m 16G \
  -drive file=disk.qcow2,if=virtio -drive file=seed.iso,media=cdrom \
  -chardev socket,id=tpm,path=tpm/swtpm.sock -tpmdev emulator,id=tpm0,chardev=tpm -device tpm-tis,tpmdev=tpm0 \
  -nic "user,model=virtio-net-pci,hostfwd=tcp:127.0.0.1:$port-:22" \
  -display none -serial file:serial.log -pidfile qemu.pid -daemonize

cat <<EOF
Booting. Connect with:
  ssh -i $dir/vm_key -p $port -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null root@127.0.0.1
Stop it from inside with \`sudo poweroff\`: killing QEMU loses unflushed writes.
Start over with: rm $dir/disk.qcow2
EOF
