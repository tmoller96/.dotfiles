#!/usr/bin/env bash
# setup.sh: Cross-platform entry point for dotfiles setup
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if [[ "$OSTYPE" == "darwin"* ]]; then
  echo "Detected macOS. Running mac/setup-mac.sh..."
  bash "$SCRIPT_DIR/mac/setup-mac.sh"
elif grep -qi microsoft /proc/version 2>/dev/null; then
  echo "Detected WSL. Running wsl/setup-wsl.sh..."
  bash "$SCRIPT_DIR/wsl/setup-wsl.sh"
elif [[ "$OSTYPE" == "cygwin" ]] || [[ "$OSTYPE" == "msys" ]]; then
  echo "Detected Windows. Running windows/setup-windows.sh..."
  bash "$SCRIPT_DIR/windows/setup-windows.sh"
else
  echo "Unsupported OS: $OSTYPE"
  exit 1
fi
