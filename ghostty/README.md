# Ghostty

Configuration for the [ghostty](https://ghostty.org/) terminal emulator. Mirrors the kitty setup (same font, background, and tab bindings) so either terminal feels the same.

## Settings

- **Font:** JetBrainsMono Nerd Font Mono (see [kitty/README.md](../kitty/README.md) for font installation)
- **Theme:** Catppuccin Mocha (built into ghostty)
- **Scrollback:** ~10MB (ghostty measures scrollback in bytes, not lines)
- **Window:** starts fullscreen (`fullscreen = true`; swap for `maximize = true` to keep the titlebar)

## Key Bindings

Mac muscle memory works on both OSes. macOS already binds these to **Cmd** out of the box; Linux has no Cmd key (and GNOME claims most Super combos), so it uses **Alt**, which sits in the same spot on the keyboard.

| macOS | Linux | Action |
|-------|-------|--------|
| `Cmd+T` | `Alt+T` | New tab |
| `Cmd+1-9` | `Alt+1-9` | Switch to tab 1-9 |
| `Cmd+D` | `Alt+D` | New split (right) |
| `Cmd+Shift+D` | `Alt+Shift+D` | New split (down) |
| `Cmd+H/J/K/L` | `Alt+H/J/K/L` | Focus split left/down/up/right |
| `Ctrl+Shift+C` | `Ctrl+Shift+C` | Copy to clipboard |
| `Ctrl+Shift+V` | `Ctrl+Shift+V` | Paste from clipboard |
| `Ctrl+Shift+L` | `Ctrl+Shift+L` | Clear screen |
| `Cmd+Enter` | `Ctrl+Enter` | Toggle fullscreen |
| `Cmd+Shift+,` | `Ctrl+Shift+,` | Reload config |

> On Linux, `Alt+<key>` normally sends Meta to the shell, so these shadow some readline keys (notably `Alt+D` = delete-word).

## Install

- **macOS:** `brew install --cask ghostty` or download from [ghostty.org](https://ghostty.org/download)
- **Linux:** see [ghostty.org/docs/install](https://ghostty.org/docs/install/binary)

The config symlinks to `~/.config/ghostty/config`, which ghostty reads on both macOS and Linux.
