#!/bin/sh
# Package installer
# Detects OS and installs packages via brew (macOS) or apt (Ubuntu/Debian).
#
# Usage:
#   sh packages/install.sh

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

detect_os() {
  case "$(uname -s)" in
    Darwin) echo "macos" ;;
    Linux)
      if [ -f /etc/debian_version ]; then
        echo "debian"
      else
        echo "linux-unknown"
      fi
      ;;
    *) echo "unknown" ;;
  esac
}

install_macos() {
  if ! command -v brew >/dev/null 2>&1; then
    echo "Homebrew not found. Install it first:"
    # shellcheck disable=SC2016 # printing a literal command, not expanding it
    echo '  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"'
    exit 1
  fi

  echo "Installing packages via Homebrew..."
  brew bundle install --file="$SCRIPT_DIR/Brewfile"
  echo "Done."
}

install_debian() {
  echo "Updating apt package list..."
  sudo apt update

  # Read package names from apt.txt, skipping comments and blank lines
  packages=""
  while IFS= read -r line; do
    line="$(echo "$line" | sed 's/#.*//' | tr -d '[:space:]')"
    if [ -n "$line" ]; then
      packages="$packages $line"
    fi
  done < "$SCRIPT_DIR/apt.txt"

  available=""
  unavailable=""
  for pkg in $packages; do
    if apt-cache show "$pkg" >/dev/null 2>&1; then
      available="$available $pkg"
    else
      unavailable="$unavailable $pkg"
    fi
  done

  if [ -n "$unavailable" ]; then
    echo "Skipping packages not in apt:$unavailable"
    echo "Check packages/apt.txt for manual install instructions."
  fi

  echo "Installing packages via apt..."
  # shellcheck disable=SC2086 # word splitting of the package list is intended
  sudo apt install -y $available

  # fd and bat ship under different binary names on Debian/Ubuntu
  mkdir -p "$HOME/.local/bin"

  if command -v fdfind >/dev/null 2>&1 && ! command -v fd >/dev/null 2>&1; then
    ln -sf "$(which fdfind)" "$HOME/.local/bin/fd"
    echo "Symlinked fdfind -> fd"
  fi

  if command -v batcat >/dev/null 2>&1 && ! command -v bat >/dev/null 2>&1; then
    ln -sf "$(which batcat)" "$HOME/.local/bin/bat"
    echo "Symlinked batcat -> bat"
  fi

  echo "Done."
}

OS="$(detect_os)"

case "$OS" in
  macos)
    install_macos
    ;;
  debian)
    install_debian
    ;;
  linux-unknown)
    echo "Unsupported Linux distribution. Only Debian/Ubuntu is supported."
    echo "Install packages manually, see packages/apt.txt for the list."
    exit 1
    ;;
  *)
    echo "Unsupported OS: $(uname -s)"
    exit 1
    ;;
esac
