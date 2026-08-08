# WezTerm

Configuration for the [WezTerm](https://wezterm.org/) terminal emulator. Mirrors the kitty/ghostty setup (same font, theme, and tab/split bindings). SSH domains are added per machine in a gitignored override file.

## Settings

- **Font:** JetBrainsMono Nerd Font Mono (see [kitty/README.md](../kitty/README.md) for font installation)
- **Theme:** Catppuccin Mocha (built into wezterm)
- **Scrollback:** 5000 lines (matches kitty)
- **Window:** starts fullscreen (swap `toggle_fullscreen()` for `maximize()` in the `gui-startup` hook to keep the titlebar)

## Key Bindings

Same scheme as ghostty: **Cmd** on macOS, **Alt** on Linux (no Cmd key, and GNOME claims most Super combos).

| macOS | Linux | Action |
|-------|-------|--------|
| `Cmd+T` | `Alt+T` | New tab |
| `Cmd+1-9` | `Alt+1-9` | Switch to tab 1-9 |
| `Cmd+D` | `Alt+D` | New split (right) |
| `Cmd+Shift+D` | `Alt+Shift+D` | New split (down) |
| `Cmd+H/J/K/L` | `Alt+H/J/K/L` | Focus split left/down/up/right |
| `Ctrl+Shift+C` | `Ctrl+Shift+C` | Copy to clipboard |
| `Ctrl+Shift+V` | `Ctrl+Shift+V` | Paste from clipboard |
| `Ctrl+Shift+L` | `Ctrl+Shift+L` | Clear scrollback + screen |

> On Linux, `Alt+<key>` normally sends Meta to the shell, so these shadow some readline keys (notably `Alt+D` = delete-word).

## Machine-specific overrides (SSH domains, etc.)

`wezterm/custom.lua` (gitignored) is loaded at the end of the config if present. Return a function that mutates the config. This is where SSH domains go, since they name real machines. The example adds a domain that ssh's into a host from `~/.ssh/config` and lands in a persistent tmux session, plus a key that opens it in a new tab:

```lua
local wezterm = require("wezterm")
local act = wezterm.action

return function(config)
  config.font_size = 14

  table.insert(config.ssh_domains, {
    name = "myserver",
    remote_address = "myserver",           -- resolves via ~/.ssh/config
    multiplexing = "None",                 -- plain ssh, nothing to install remotely
    default_prog = { "tmux", "new", "-A", "-s", "main" },  -- attach-or-create
  })

  table.insert(config.keys, {
    key = "s",
    mods = "ALT",                          -- SUPER on macOS
    action = act.SpawnTab({ DomainName = "myserver" }),
  })
end
```

There are three ways into a domain: the keybinding, `wezterm connect myserver` from any shell, or the launcher menu (right-click the `+` on the tab bar). Since the domain runs `tmux new -A`, the session survives disconnects and terminal swaps. Detach with `Ctrl-B D` or just close the tab. `multiplexing = "None"` means each tab is a plain ssh connection and tmux handles persistence. The alternative is running `wezterm-mux-server` on the remote to keep native wezterm tabs alive, but that adds a daemon to manage.

## Install

- **macOS:** `brew install --cask wezterm` or download from [wezterm.org](https://wezterm.org/installation.html)
- **Linux:** apt repo, flatpak, or AppImage per [wezterm.org/install/linux](https://wezterm.org/install/linux.html)

The config symlinks to `~/.config/wezterm/`, and wezterm reads `wezterm.lua` from there on both macOS and Linux.

This is an opt-in module: `install.sh` links it only when the `wezterm` binary is already installed, or when run with `--with wezterm`.
