# Dotfiles

Personal dotfiles for zsh, nvim, vim, and kitty terminal. XDG-compliant where possible.

## Structure

```
dotfiles/
├── kitty/          → ~/.config/kitty/
├── nvim/           → ~/.config/nvim/
├── zsh/
│   ├── .zshenv     → ~/.zshenv (sets ZDOTDIR)
│   ├── .zshrc      → ~/.config/zsh/.zshrc
│   └── zsh.d/      → ~/.config/zsh/zsh.d/
├── vim/
│   ├── vimrc       → ~/.vimrc
│   └── vim/        → ~/.vim/
└── install.sh
```

## Install

```sh
# Force install (overwrites existing config)
sh install.sh -f

# Dry run (show what would happen without changing anything)
sh install.sh --dry-run

# Force install, quiet mode
sh install.sh -fq

# Custom directories
sh install.sh -f --home ~/custom --config ~/custom/.config
```

### Flags

| Flag | Description |
|------|-------------|
| `-f` | Force mode. Overwrites existing files/symlinks. |
| `-q` | Quiet mode. Suppresses console output. |
| `--dry-run` | Dry run. Shows what would happen without making changes. |
| `--home <dir>` | Custom home directory. Default: `~` |
| `--config <dir>` | Custom config directory. Default: `~/.config` |

## Dependencies

### Required

| Tool | Purpose | macOS | Linux |
|------|---------|-------|-------|
| [git](https://git-scm.com/downloads) | Version control, plugin management | `xcode-select --install` | `sudo apt install git` |
| [zsh](https://www.zsh.org/) | Shell | Ships with macOS | `sudo apt install zsh` |
| [neovim 0.11+](https://github.com/neovim/neovim/blob/master/INSTALL.md) | Editor | `brew install neovim` | See [install guide](https://github.com/neovim/neovim/blob/master/INSTALL.md) |
| [kitty](https://sw.kovidgoyal.net/kitty/binary/) | Terminal emulator | `curl -L https://sw.kovidgoyal.net/kitty/installer.sh \| sh /dev/stdin` | Same |
| [JetBrainsMono Nerd Font](https://www.nerdfonts.com/font-downloads) | Terminal/editor font | See [kitty/README.md](kitty/README.md) | See [kitty/README.md](kitty/README.md) |

### Neovim dependencies

| Tool | Purpose | macOS | Linux |
|------|---------|-------|-------|
| [tree-sitter-cli](https://github.com/tree-sitter/tree-sitter/blob/master/cli/README.md) | Parser compilation (nvim 0.11+) | `brew install tree-sitter-cli` | `npm install -g tree-sitter-cli` or `cargo install tree-sitter-cli` |
| [ripgrep](https://github.com/BurntSushi/ripgrep) | Telescope live grep | `brew install ripgrep` | `sudo apt install ripgrep` |
| [fd](https://github.com/sharkdp/fd) | Telescope file finder | `brew install fd` | `sudo apt install fd-find` |
| [nvm](https://github.com/nvm-sh/nvm) | Node version management (LSP servers, typescript-tools) | Auto-managed by zsh-nvm plugin | Auto-managed by zsh-nvm plugin |
| C compiler | Treesitter parser compilation | `xcode-select --install` | `sudo apt install build-essential` |

### Language runtimes

Install the runtimes for languages you work in. Mason auto-installs LSP servers, but the runtimes themselves are needed.

| Tool | Purpose | macOS | Linux |
|------|---------|-------|-------|
| [miniconda](https://docs.anaconda.com/miniconda/install/) | Python (pyright LSP) | See [install guide](https://docs.anaconda.com/miniconda/install/#macos) | See [install guide](https://docs.anaconda.com/miniconda/install/#linux) |
| [go](https://go.dev/dl/) | gopls LSP | `brew install go` | See [go.dev/dl](https://go.dev/dl/) |
| [rust/cargo](https://www.rust-lang.org/tools/install) | rust_analyzer LSP | `curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs \| sh` | Same |
| [node](https://github.com/nvm-sh/nvm) | typescript-tools, vue-ls, jsonls, yamlls | `nvm install --lts` | `nvm install --lts` |

### Zsh utilities (optional)

| Tool | Purpose | macOS | Linux |
|------|---------|-------|-------|
| [openssl](https://www.openssl.org/) | Encryption/decryption functions | Ships with macOS (LibreSSL) | `sudo apt install openssl` |
| [rclone](https://rclone.org/install/) | KeePass sync (functions-custom) | `brew install rclone` | `sudo apt install rclone` |

## Machine-Specific Config

Files matching `*custom.*` and `*secret.*` in `zsh/zsh.d/` are gitignored. Use these for machine-specific environment variables, paths, and tool configs that shouldn't be shared across machines.

## First Run

On first shell launch after install:
1. zplug auto-clones to `~/.local/share/zplug/`
2. zplug installs all configured plugins
3. NVM installs via the zsh-nvm plugin

On first nvim launch:
1. lazy.nvim bootstraps itself
2. All plugins install automatically
3. Mason installs configured LSP servers and formatters
