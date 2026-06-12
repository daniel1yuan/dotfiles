#!/bin/sh
# Runtime installer
#
# Installs node + python via mise so neovim's language-dependent LSPs
# (typescript-tools, vue_ls, jsonls, yamlls, pyright, ruff) activate.
# The nvim config gates those servers on the runtimes existing; after this
# script runs, reopen nvim and Mason installs the servers automatically.
#
# Usage:
#   sh packages/runtimes.sh

set -e

if ! command -v mise >/dev/null 2>&1; then
  echo "mise not found, installing via https://mise.run ..."
  curl -fsSL https://mise.run | sh
  export PATH="$HOME/.local/bin:$PATH"
fi

echo "Installing runtimes via mise..."
mise use -g node@lts
mise use -g python@3.12

echo ""
echo "Done. Installed:"
mise ls --global 2>/dev/null || true
echo ""
echo "Reopen nvim and Mason will install the node/python LSPs and formatters."
echo "Optional extras:"
echo "  mise use -g go@latest"
echo "  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh   # rust"
