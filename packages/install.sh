#!/bin/sh
# Package installer
#
# One-shot bootstrap for everything the dotfiles expect, regardless of system:
#   - OS packages via brew (macOS) or apt (Ubuntu/Debian)
#   - mise itself, plus CLI tools apt can't provide (Linux, packages/mise.txt)
#   - neovim 0.12+ (Linux: latest stable to ~/.local via packages/nvim.sh)
#   - node + python runtimes via mise (enables the nvim LSPs)
#   - JetBrainsMono Nerd Font
#
# Safe to re-run: every step skips or no-ops when already done. Steps that
# can't run (no sudo, no brew) warn and continue instead of aborting.
#
# Usage:
#   sh packages/install.sh

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

# Tools installed during this run (mise, nvim) land in these
PATH="$HOME/.local/bin:$HOME/.local/share/mise/shims:$PATH"

NERD_FONT_VERSION="3.4.0"

have() { command -v "$1" >/dev/null 2>&1; }

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

OS="$(detect_os)"

# --- OS packages ---

install_macos_packages() {
  if ! have brew; then
    echo "Homebrew not found. Install it first, then re-run:"
    # shellcheck disable=SC2016 # printing a literal command, not expanding it
    echo '  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"'
    return 1
  fi

  echo "Installing packages via Homebrew..."
  brew bundle install --file="$SCRIPT_DIR/Brewfile"
}

install_debian_packages() {
  # apt needs sudo; in non-interactive contexts (no TTY, no cached
  # credentials) skip it rather than hang or fail the whole install
  if ! sudo -n true 2>/dev/null && [ ! -t 0 ]; then
    echo "Skipping apt packages: sudo needs a password and there's no terminal."
    echo "Run 'sh packages/install.sh' interactively to install them."
    return 0
  fi

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
  fi

  echo "Installing packages via apt..."
  # shellcheck disable=SC2086 # word splitting of the package list is intended
  sudo apt install -y $available

  # fd and bat ship under different binary names on Debian/Ubuntu
  mkdir -p "$HOME/.local/bin"

  if have fdfind && ! have fd; then
    ln -sf "$(command -v fdfind)" "$HOME/.local/bin/fd"
    echo "Symlinked fdfind -> fd"
  fi

  if have batcat && ! have bat; then
    ln -sf "$(command -v batcat)" "$HOME/.local/bin/bat"
    echo "Symlinked batcat -> bat"
  fi
}

# --- mise and mise-managed tools ---

ensure_mise() {
  if have mise; then
    return 0
  fi
  echo "Installing mise..."
  curl -fsSL https://mise.run | sh
  if ! have mise; then
    echo "mise install failed." >&2
    return 1
  fi
}

install_mise_tools() {
  ensure_mise || return 1

  echo "Installing CLI tools via mise (packages/mise.txt)..."
  while IFS= read -r line; do
    line="$(echo "$line" | sed 's/#.*//' | tr -d '[:space:]')"
    if [ -n "$line" ]; then
      mise use -g "$line"
    fi
  done < "$SCRIPT_DIR/mise.txt"
}

install_runtimes() {
  ensure_mise || return 1

  echo "Installing node + python runtimes via mise (used by the nvim LSPs)..."
  mise use -g node@lts
  mise use -g python@3.12
}

# --- neovim ---

nvim_is_current() {
  have nvim || return 1
  installed="$(nvim --version | head -1 | sed 's/^NVIM v//')"
  # The nvim config needs 0.12+ (nvim-treesitter main branch)
  [ "$(printf '%s\n' "0.12.0" "$installed" | sort -V | head -1)" = "0.12.0" ]
}

install_nvim() {
  if nvim_is_current; then
    echo "neovim is current: $(nvim --version | head -1)"
    return 0
  fi

  if [ "$OS" = "macos" ]; then
    echo "neovim is missing or older than 0.12; update it via brew:"
    echo "  brew upgrade neovim"
    return 0
  fi

  echo "neovim is missing or older than 0.12; installing latest stable..."
  sh "$SCRIPT_DIR/nvim.sh"
}

# --- Nerd Font (terminals are configured for JetBrainsMono Nerd Font) ---

install_fonts() {
  if [ "$OS" = "macos" ]; then
    font_dir="$HOME/Library/Fonts"
  else
    font_dir="$HOME/.local/share/fonts"
  fi

  if ls "$font_dir"/JetBrainsMono*NerdFont* >/dev/null 2>&1; then
    echo "JetBrainsMono Nerd Font already installed."
    return 0
  fi

  if ! have unzip; then
    echo "Skipping font install: unzip not available."
    return 0
  fi

  echo "Installing JetBrainsMono Nerd Font..."
  font_zip="$(mktemp /tmp/jbmono.XXXXXX.zip)"
  curl -fsSL "https://github.com/ryanoasis/nerd-fonts/releases/download/v$NERD_FONT_VERSION/JetBrainsMono.zip" -o "$font_zip"
  mkdir -p "$font_dir"
  unzip -oq "$font_zip" -d "$font_dir"
  rm -f "$font_zip"

  if [ "$OS" != "macos" ] && have fc-cache; then
    fc-cache -f >/dev/null
  fi
  echo "Font installed to $font_dir"
}

# --- Main ---

case "$OS" in
  macos)
    install_macos_packages || echo "Continuing without Homebrew packages."
    ;;
  debian)
    install_debian_packages || echo "Continuing without apt packages."
    install_mise_tools
    ;;
  linux-unknown)
    echo "Unknown Linux distribution: skipping OS packages (see packages/apt.txt"
    echo "for the list); installing what mise can provide."
    install_mise_tools
    ;;
  *)
    echo "Unsupported OS: $(uname -s)" >&2
    exit 1
    ;;
esac

install_nvim
install_runtimes
install_fonts

echo "Done."
