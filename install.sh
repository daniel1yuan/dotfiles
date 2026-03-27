#!/bin/sh
# Dotfiles installer
#
# Usage:
#   sh install.sh                              Install (skip existing)
#   sh install.sh -f                           Force install (backs up and overwrites)
#   sh install.sh --dry-run                    Show what would happen
#   sh install.sh --uninstall                  Remove symlinks created by this script
#   sh install.sh --skip-packages              Skip package installation
#   sh install.sh -f --home ~/x --config ~/y   Custom directories

set -e

HOME_DIR="$HOME"
CONFIG_DIR="$HOME/.config"
WORKING_DIR="$(cd "$(dirname "$0")" && pwd)"
BACKUP_DIR="$HOME/.dotfiles-backup/$(date +%Y%m%d-%H%M%S)"

FORCE=0
VERBOSE=1
DRY_RUN=0
UNINSTALL=0
SKIP_PACKAGES=0

while [ $# -gt 0 ]; do
  case "$1" in
    -f) FORCE=1 ;;
    -q) VERBOSE=0 ;;
    -fq|-qf) FORCE=1; VERBOSE=0 ;;
    --dry-run) DRY_RUN=1; VERBOSE=1 ;;
    --uninstall|--cleanup) UNINSTALL=1 ;;
    --skip-packages) SKIP_PACKAGES=1 ;;
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
zsh/zsh_plugins.txt:$CONFIG_DIR/zsh/zsh_plugins.txt
zsh/zsh.d:$CONFIG_DIR/zsh/zsh.d
nvim:$CONFIG_DIR/nvim
kitty:$CONFIG_DIR/kitty
starship/starship.toml:$CONFIG_DIR/starship.toml
"

# --- Dependency validation ---

REQUIRED_TOOLS="git zsh nvim kitty"
OPTIONAL_TOOLS="mise fzf fd bat eza zoxide rg starship"

check_deps() {
  log "Checking dependencies..."
  missing_required=""
  missing_optional=""

  for tool in $REQUIRED_TOOLS; do
    if command -v "$tool" >/dev/null 2>&1; then
      log "  [ok] $tool"
    else
      log "  [missing] $tool (required)"
      missing_required="$missing_required $tool"
    fi
  done

  for tool in $OPTIONAL_TOOLS; do
    if command -v "$tool" >/dev/null 2>&1; then
      log "  [ok] $tool"
    else
      log "  [missing] $tool (optional)"
      missing_optional="$missing_optional $tool"
    fi
  done

  if [ -n "$missing_optional" ]; then
    log ""
    log "Optional tools missing:$missing_optional"
    log "Run 'sh packages/install.sh' to install them."
  fi

  if [ -n "$missing_required" ]; then
    log ""
    log "Required tools missing:$missing_required"
    log "Install them before continuing."
    return 1
  fi

  log ""
  return 0
}

# --- Backup ---

backup() {
  local target="$1"
  if [ -e "$target" ] || [ -L "$target" ]; then
    if [ $DRY_RUN -eq 0 ]; then
      mkdir -p "$BACKUP_DIR"
      mv "$target" "$BACKUP_DIR/"
      log "  [backup] $target -> $BACKUP_DIR/"
    else
      log "  [backup] $target -> $BACKUP_DIR/ (dry run)"
    fi
  fi
}

# --- Link ---

link() {
  local source="$WORKING_DIR/$1"
  local target="$2"

  # Already linked correctly
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
    backup "$target"
  fi

  log "  [link] $source -> $target"
  if [ $DRY_RUN -eq 0 ]; then
    ln -s "$source" "$target"
  fi
}

# --- Unlink ---

unlink() {
  local source="$WORKING_DIR/$1"
  local target="$2"

  if [ -L "$target" ] && [ "$(readlink "$target")" = "$source" ]; then
    log "  [remove] $target"
    if [ $DRY_RUN -eq 0 ]; then
      rm "$target"
    fi
  elif [ -L "$target" ] || [ -e "$target" ]; then
    log "  [skip] $target (not managed by dotfiles)"
  else
    log "  [ok] $target (already absent)"
  fi
}

# --- Uninstall ---

if [ $UNINSTALL -eq 1 ]; then
  if [ $DRY_RUN -eq 1 ]; then
    log "Dry run — no changes will be made"
  fi
  log "Removing dotfile symlinks..."
  log "  Home:   $HOME_DIR"
  log "  Config: $CONFIG_DIR"
  log ""

  for entry in $LINKS; do
    source="${entry%%:*}"
    target="${entry#*:}"
    if [ -n "$source" ] && [ -n "$target" ]; then
      unlink "$source" "$target"
    fi
  done

  # Remove empty parent directories created by install
  if [ $DRY_RUN -eq 0 ]; then
    rmdir "$CONFIG_DIR/zsh" 2>/dev/null || true
  fi

  log ""
  log "Done. Config files that weren't symlinks were left in place."
  exit 0
fi

# --- Install ---

if [ $DRY_RUN -eq 1 ]; then
  log "Dry run — no changes will be made"
fi

if [ $FORCE -eq 1 ]; then
  log "Force mode — existing files will be backed up to $BACKUP_DIR"
fi

# Step 1: Install packages
if [ $SKIP_PACKAGES -eq 0 ] && [ $DRY_RUN -eq 0 ]; then
  log ""
  log "Step 1: Installing packages..."
  sh "$WORKING_DIR/packages/install.sh"
  log ""
fi

# Step 2: Check dependencies
log "Step 2: Checking dependencies..."
if ! check_deps; then
  exit 1
fi

# Step 3: Symlink dotfiles
log "Step 3: Symlinking dotfiles..."
log "  Home:   $HOME_DIR"
log "  Config: $CONFIG_DIR"
log ""

if [ $DRY_RUN -eq 0 ]; then
  mkdir -p "$CONFIG_DIR/zsh"
fi

for entry in $LINKS; do
  source="${entry%%:*}"
  target="${entry#*:}"
  if [ -n "$source" ] && [ -n "$target" ]; then
    link "$source" "$target"
  fi
done

log ""
log "Done. Restart your shell to apply changes."
