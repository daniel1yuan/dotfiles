#!/bin/sh
# Secrets infrastructure setup
#
# Creates the ~/.secrets/ directory structure and generates an age key
# for use with sops. Safe to run multiple times — never overwrites existing
# files or directories.
#
# Usage:
#   sh secrets/setup.sh              Set up secrets infrastructure
#   sh secrets/setup.sh --dry-run    Show what would happen
#
# This script will NOT:
#   - Overwrite any existing file or directory
#   - Delete anything
#   - Modify existing .sops.yaml or age keys
#   - Touch any existing secrets
#   - Symlink anything from the dotfiles repo

set -e

SECRETS_DIR="$HOME/.secrets"
AGE_KEY_DIR="$SECRETS_DIR/age"
AGE_KEY_FILE="$AGE_KEY_DIR/keys.txt"
SOPS_CONFIG="$SECRETS_DIR/.sops.yaml"

DRY_RUN=0

while [ $# -gt 0 ]; do
  case "$1" in
    --dry-run) DRY_RUN=1 ;;
    -*)
      echo "Unknown option: $1" >&2; exit 1 ;;
  esac
  shift
done

log() { echo "$1"; }

# --- Preflight checks ---

if ! command -v age-keygen >/dev/null 2>&1; then
  echo "Error: age is not installed." >&2
  echo "  macOS:  brew install age" >&2
  echo "  Linux:  apt install age (or: mise use -g age@latest)" >&2
  exit 1
fi

if ! command -v sops >/dev/null 2>&1; then
  echo "Error: sops is not installed." >&2
  echo "  macOS:  brew install sops" >&2
  echo "  Linux:  mise use -g sops@latest" >&2
  exit 1
fi

# --- Directory structure ---

create_dir() {
  local dir="$1"
  if [ -d "$dir" ]; then
    log "  [exists] $dir"
  elif [ $DRY_RUN -eq 1 ]; then
    log "  [create] $dir (dry run)"
  else
    mkdir -p "$dir"
    chmod 700 "$dir"
    log "  [create] $dir"
  fi
}

log "Setting up secrets directory structure..."
create_dir "$SECRETS_DIR"
create_dir "$AGE_KEY_DIR"
create_dir "$SECRETS_DIR/env"
create_dir "$SECRETS_DIR/keys"
create_dir "$SECRETS_DIR/db"
log ""

# --- Age key generation ---

if [ -f "$AGE_KEY_FILE" ]; then
  log "Age key already exists — not overwriting."
  PUBLIC_KEY=$(grep -o 'age1[a-z0-9]*' "$AGE_KEY_FILE" | head -1)
  log "  Public key: $PUBLIC_KEY"
else
  if [ $DRY_RUN -eq 1 ]; then
    log "Would generate age key at $AGE_KEY_FILE (dry run)"
  else
    age-keygen -o "$AGE_KEY_FILE" 2>&1
    chmod 600 "$AGE_KEY_FILE"
    PUBLIC_KEY=$(grep -o 'age1[a-z0-9]*' "$AGE_KEY_FILE" | head -1)
    log "Age key generated."
    log "  Private key: $AGE_KEY_FILE"
    log "  Public key:  $PUBLIC_KEY"
  fi
fi
log ""

# --- .sops.yaml ---

if [ -f "$SOPS_CONFIG" ]; then
  log ".sops.yaml already exists — not overwriting."
  log "  To add this machine's key, edit $SOPS_CONFIG"
  log "  and add the public key above to the age recipients list."
else
  if [ $DRY_RUN -eq 1 ]; then
    log "Would create $SOPS_CONFIG (dry run)"
  else
    PUBLIC_KEY=$(grep -o 'age1[a-z0-9]*' "$AGE_KEY_FILE" | head -1)
    cat > "$SOPS_CONFIG" << EOF
# sops configuration for secrets encryption
# Add age public keys for each machine that should be able to decrypt.
# After adding a new key, re-encrypt existing files:
#   sops updatekeys ~/.secrets/env/global.env

creation_rules:
  - path_regex: \.env$
    age: >-
      $PUBLIC_KEY
EOF
    chmod 600 "$SOPS_CONFIG"
    log "Created $SOPS_CONFIG with this machine's public key."
  fi
fi
log ""

# --- Next steps ---

log "SOPS_AGE_KEY_FILE and SOPS_CONFIG are already exported in the dotfiles zsh config."
log ""
log "Next steps (reload your shell first):"
log "  1. Create your first encrypted env file:"
log "     secrets-edit"
log ""
log "  2. Add entries as export KEY=\"VALUE\", one per line."
log "     sops opens your editor with decrypted content and re-encrypts on save."
log "     All .env files in ~/.secrets/env/ are sourced automatically at shell init."
log ""
log "  3. To add another machine:"
log "     a. Run this setup script on the new machine"
log "     b. Copy the new machine's public key"
log "     c. Add it to ~/.secrets/.sops.yaml on any machine"
log "     d. Re-encrypt: sops updatekeys ~/.secrets/env/global.env"
log "     e. Sync the updated .sops.yaml and .env files to the new machine (not age/)"
