#!/usr/bin/env bash
# setup.sh: Cross-platform entry point for dotfiles setup
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if [[ "$OSTYPE" == "darwin"* ]]; then
  echo "Detected macOS. Running mac/setup-mac.sh..."
  bash "$SCRIPT_DIR/mac/setup-mac.sh"
elif grep -qi microsoft /proc/version 2>/dev/null; then
  echo "Detected WSL. Running windows/setup-windows.sh..."
  bash "$SCRIPT_DIR/windows/setup-windows.sh"
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
  echo "Detected Linux. Running windows/setup-windows.sh (customize as needed)..."
  bash "$SCRIPT_DIR/windows/setup-windows.sh"
else
  echo "Unsupported OS: $OSTYPE"
  exit 1
fi
