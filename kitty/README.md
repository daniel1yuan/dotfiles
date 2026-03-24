# Kitty

Configuration for the kitty terminal emulator.

## Settings

- **Font:** JetBrainsMono Nerd Font Mono
- **Background:** #232323
- **Scrollback:** 5000 lines
- **Tab bar:** Separator style

## Key Bindings

| Binding | Action |
|---------|--------|
| `Ctrl+Shift+C` | Copy to clipboard |
| `Ctrl+Shift+V` | Paste from clipboard |
| `Ctrl+Shift+L` | Clear terminal |
| `Super+L` | Next layout |
| `Alt+1-5` | Switch to tab 1-5 |

## JetBrainsMono Nerd Font Installation

[Nerd Font Downloads](https://www.nerdfonts.com/font-downloads)

### macOS

```sh
curl -fLo /tmp/JetBrainsMono.zip https://github.com/ryanoasis/nerd-fonts/releases/download/v3.4.0/JetBrainsMono.zip
unzip -o /tmp/JetBrainsMono.zip -d ~/Library/Fonts
rm /tmp/JetBrainsMono.zip
```

### Linux

```sh
curl -fLo /tmp/JetBrainsMono.zip https://github.com/ryanoasis/nerd-fonts/releases/download/v3.4.0/JetBrainsMono.zip
mkdir -p ~/.local/share/fonts
unzip -o /tmp/JetBrainsMono.zip -d ~/.local/share/fonts
fc-cache -fv
rm /tmp/JetBrainsMono.zip
```
