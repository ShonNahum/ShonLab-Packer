#!/usr/bin/env bash
set -euo pipefail

echo "==> Installing Ubuntu-specific packages..."
sudo apt-get install -y -qq \
  ubuntu-advantage-tools \
  open-iscsi \
  nfs-common

echo "==> Disabling apt auto-update timers..."
sudo systemctl disable apt-daily.timer || true
sudo systemctl disable apt-daily-upgrade.timer || true

echo "==> Ubuntu setup complete."