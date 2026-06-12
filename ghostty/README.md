# Ghostty

Configuration for the [ghostty](https://ghostty.org/) terminal emulator. Mirrors the kitty setup (same font, background, and tab bindings) so either terminal feels the same.

## Settings

- **Font:** JetBrainsMono Nerd Font Mono (see [kitty/README.md](../kitty/README.md) for font installation)
- **Theme:** Catppuccin Mocha (built into ghostty)
- **Scrollback:** ~10MB (ghostty measures scrollback in bytes, not lines)

## Key Bindings

| Binding | Action |
|---------|--------|
| `Ctrl+Shift+C` | Copy to clipboard |
| `Ctrl+Shift+V` | Paste from clipboard |
| `Ctrl+Shift+L` | Clear screen |
| `Alt+H/J/K/L` | Focus split left/down/up/right |
| `Alt+1-5` | Switch to tab 1-5 |

## Install

- **macOS:** `brew install --cask ghostty` or download from [ghostty.org](https://ghostty.org/download)
- **Linux:** see [ghostty.org/docs/install](https://ghostty.org/docs/install/binary)

The config symlinks to `~/.config/ghostty/config`, which ghostty reads on both macOS and Linux.
