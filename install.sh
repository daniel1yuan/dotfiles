#!/bin/sh
# Dotfiles installer
#
# Usage:
#   sh install.sh -f                        Force install (overwrites existing)
#   sh install.sh -fq                       Force install, quiet mode
#   sh install.sh --dry-run                  Dry run (show what would happen)
#   sh install.sh -f --home ~/custom        Custom home directory
#   sh install.sh -f --config ~/custom-cfg  Custom config directory

HOME_DIR="$HOME"
CONFIG_DIR="$HOME/.config"
WORKING_DIR="$(cd "$(dirname "$0")" && pwd)"

FORCE=0
VERBOSE=1
DRY_RUN=0

while [ $# -gt 0 ]; do
  case "$1" in
    -f) FORCE=1 ;;
    -q) VERBOSE=0 ;;
    -fq|-qf) FORCE=1; VERBOSE=0 ;;
    --dry-run) DRY_RUN=1; VERBOSE=1 ;;
    --home)
      if [ -z "$2" ] || [ "${2#-}" != "$2" ]; then
        echo "Error: --home requires a directory argument" >&2; exit 1
      fi
      HOME_DIR="$2"; shift ;;
    --config)
      if [ -z "$2" ] || [ "${2#-}" != "$2" ]; then
        echo "Error: --config requires a directory argument" >&2; exit 1
      fi
      CONFIG_DIR="$2"; shift ;;
    -*)
      echo "Unknown option: $1" >&2; exit 1 ;;
    *)
      echo "Unknown argument: $1" >&2; exit 1 ;;
  esac
  shift
done

# Resolve to absolute paths
HOME_DIR="$(cd "$HOME_DIR" && pwd)"
CONFIG_DIR="$(cd "$CONFIG_DIR" 2>/dev/null && pwd || echo "$CONFIG_DIR")"

log() {
  if [ $VERBOSE -eq 1 ]; then
    echo "$1"
  fi
}

# Symlink map: source (relative to repo) -> target (absolute path)
# Add new tools here
LINKS="
zsh/.zshenv:$HOME_DIR/.zshenv
zsh/.zshrc:$CONFIG_DIR/zsh/.zshrc
zsh/zsh.d:$CONFIG_DIR/zsh/zsh.d
nvim:$CONFIG_DIR/nvim
kitty:$CONFIG_DIR/kitty
vim/vimrc:$HOME_DIR/.vimrc
vim/vim:$HOME_DIR/.vim
"

link() {
  local source="$WORKING_DIR/$1"
  local target="$2"

  # Skip the linking if it's already linked
  if [ -L "$target" ] && [ "$(readlink "$target")" = "$source" ]; then
    log "  [ok] $target"
    return 0
  fi

  # Target exists but isn't the right symlink
  if [ -e "$target" ] || [ -L "$target" ]; then
    if [ $FORCE -eq 0 ]; then
      log "  [skip] $target already exists (use -f to overwrite)"
      return 1
    fi
    if [ $DRY_RUN -eq 0 ]; then
      if [ -d "$target" ] && [ ! -L "$target" ]; then
        rm -rf "$target"
      else
        rm "$target"
      fi
    fi
  fi

  log "  [link] $source -> $target"
  if [ $DRY_RUN -eq 0 ]; then
    ln -s "$source" "$target"
  fi
}

if [ $DRY_RUN -eq 1 ]; then
  log "Dry run — no changes will be made"
fi

if [ $FORCE -eq 1 ]; then
  log "Force mode activated"
fi

log "Installing dotfiles..."
log "  Home:   $HOME_DIR"
log "  Config: $CONFIG_DIR"
log ""

# Create required parent directories
if [ $DRY_RUN -eq 0 ]; then
  mkdir -p "$CONFIG_DIR/zsh"
fi

# Install all symlinks
for entry in $LINKS; do
  source="${entry%%:*}"
  target="${entry#*:}"
  if [ -n "$source" ] && [ -n "$target" ]; then
    link "$source" "$target"
  fi
done
