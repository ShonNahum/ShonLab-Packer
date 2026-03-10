#!/usr/bin/env bash
set -euo pipefail

STORAGE="local-lvm"
BRIDGE="vmbr0"
TARGET="${1:-all}"

create_ubuntu_seed() {
  local SEED_ID=8999
  local IMAGE_FILE="/tmp/ubuntu-22.04-seed.img"

  echo "==> Creating Ubuntu 22.04 seed VM..."
  wget -q --show-progress -O "$IMAGE_FILE" \
    "https://cloud-images.ubuntu.com/jammy/current/jammy-server-cloudimg-amd64.img"

  qm create $SEED_ID --name "ubuntu-22.04-seed" \
    --memory 2048 --cores 2 \
    --net0 virtio,bridge=$BRIDGE \
    --ostype l26 --machine q35 \
    --scsihw virtio-scsi-single \
    --agent enabled=1 \
    --ide2 $STORAGE:cloudinit \
    --serial0 socket --vga serial0 \
    --ciuser ubuntu --cipassword ubuntu \
    --ipconfig0 ip=dhcp

  qm importdisk $SEED_ID "$IMAGE_FILE" $STORAGE
  qm set $SEED_ID --scsi0 $STORAGE:vm-${SEED_ID}-disk-0,discard=on,iothread=1
  qm set $SEED_ID --boot c --bootdisk scsi0
  echo "✅ Ubuntu seed ready."
}

create_debian_seed() {
  local SEED_ID=8998
  local IMAGE_FILE="/tmp/debian-12-seed.qcow2"

  echo "==> Creating Debian 12 seed VM..."
  wget -q --show-progress -O "$IMAGE_FILE" \
    "https://cloud.debian.org/images/cloud/bookworm/latest/debian-12-generic-amd64.qcow2"

  qm create $SEED_ID --name "debian-12-seed" \
    --memory 2048 --cores 2 \
    --net0 virtio,bridge=$BRIDGE \
    --ostype l26 --machine q35 \
    --scsihw virtio-scsi-single \
    --agent enabled=1 \
    --ide2 $STORAGE:cloudinit \
    --serial0 socket --vga serial0 \
    --ciuser admin --cipassword packer \
    --ipconfig0 ip=dhcp 

  qm importdisk $SEED_ID "$IMAGE_FILE" $STORAGE
  qm set $SEED_ID --scsi0 $STORAGE:vm-${SEED_ID}-disk-0,discard=on,iothread=1
  qm set $SEED_ID --boot c --bootdisk scsi0
  echo "✅ Debian seed ready."
}

case "$TARGET" in
  ubuntu) create_ubuntu_seed ;;
  debian) create_debian_seed ;;
  all)    create_ubuntu_seed; create_debian_seed ;;
  *)      echo "Usage: $0 [ubuntu|debian|all]"; exit 1 ;;
esac
```