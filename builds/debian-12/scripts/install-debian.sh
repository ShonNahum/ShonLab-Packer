#!/usr/bin/env bash
set -euo pipefail

echo "==> Installing Debian-specific packages..."
sudo apt-get install -y -qq \
  open-iscsi \
  nfs-common \
  sudo

echo "==> Debian setup complete."