#!/usr/bin/env bash
set -euo pipefail

echo "==> Running base cleanup..."

sudo cloud-init clean --logs
sudo truncate -s 0 /etc/machine-id
sudo rm -f /var/lib/dbus/machine-id
sudo rm -f /var/lib/dhcp/*
sudo rm -f /etc/ssh/ssh_host_*
sudo apt-get clean
sudo sync

echo "==> Cleanup complete."