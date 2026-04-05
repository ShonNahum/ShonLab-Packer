#!/usr/bin/env bash
set -euo pipefail

echo "==> Installing CentOS-specific packages..."
sudo dnf install -y \
  iscsi-initiator-utils \
  nfs-utils

echo "==> Disabling dnf auto-update timers..."
sudo systemctl disable dnf-makecache.timer || true

echo "==> CentOS setup complete."
