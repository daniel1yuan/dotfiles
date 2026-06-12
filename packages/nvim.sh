#!/bin/sh
# Neovim installer (Linux)
#
# Ubuntu's apt neovim is years out of date, so this installs the latest
# stable release tarball to ~/.local/opt and symlinks ~/.local/bin/nvim.
# No sudo required. Safe to re-run to upgrade.
#
# macOS gets neovim from the Brewfile instead.
#
# Usage:
#   sh packages/nvim.sh

set -e

if [ "$(uname -s)" = "Darwin" ]; then
  echo "On macOS, install neovim via brew (packages/Brewfile)."
  exit 1
fi

ARCH="$(uname -m)"
case "$ARCH" in
  x86_64|aarch64) ;;
  *) echo "Unsupported architecture: $ARCH" >&2; exit 1 ;;
esac

NVIM_DIR="nvim-linux-$ARCH"
URL="https://github.com/neovim/neovim/releases/latest/download/$NVIM_DIR.tar.gz"
TARBALL="$(mktemp /tmp/nvim.XXXXXX.tar.gz)"
trap 'rm -f "$TARBALL"' EXIT

echo "Downloading latest stable neovim ($ARCH)..."
curl -fL --progress-bar "$URL" -o "$TARBALL"

mkdir -p "$HOME/.local/opt" "$HOME/.local/bin"
rm -rf "$HOME/.local/opt/$NVIM_DIR"
tar xzf "$TARBALL" -C "$HOME/.local/opt"
ln -sf "$HOME/.local/opt/$NVIM_DIR/bin/nvim" "$HOME/.local/bin/nvim"

echo "Installed: $("$HOME/.local/bin/nvim" --version | head -1) -> ~/.local/bin/nvim"

# Warn if another nvim earlier in PATH would shadow this one
RESOLVED="$(command -v nvim 2>/dev/null || true)"
if [ -n "$RESOLVED" ] && [ "$RESOLVED" != "$HOME/.local/bin/nvim" ]; then
  echo ""
  echo "Warning: 'nvim' currently resolves to $RESOLVED"
  echo "Make sure ~/.local/bin comes first in PATH (the zsh config does this),"
  echo "and consider removing old installs (e.g. sudo apt remove neovim)."
fi
