# Dotfiles

Personal dotfiles for zsh, neovim, kitty, and starship. XDG-compliant where possible.

## What's Configured

| Tool | Config | What it does |
|------|--------|-------------|
| **zsh** | `zsh/` | Shell with [antidote](https://antidote.sh/) plugins, modular config via `zsh.d/` |
| **neovim** | `nvim/` | Editor with [lazy.nvim](https://github.com/folke/lazy.nvim) plugins, LSP, treesitter, telescope |
| **kitty** | `kitty/` | Terminal emulator with custom keybindings and theme |
| **starship** | `starship/` | Minimal cross-shell prompt (directory, git, command duration) |
| **mise** | via zsh | Runtime version manager for node, python, go |

### Shell tools (initialized in zsh config)

| Tool | What it does |
|------|-------------|
| fzf | Fuzzy finder. Ctrl-R (history), Ctrl-T (files), Alt-C (directories) |
| fd | Fast file finder. Powers fzf and telescope |
| bat | Syntax-highlighted cat. Powers fzf file previews |
| eza | ls replacement with git status, icons, tree view |
| zoxide | Smarter cd. `z dot` jumps to ~/Projects/dotfiles |
| ripgrep | Fast recursive grep. Powers telescope live grep |

## Setup

### 1. Install dotfiles

Installs packages, checks dependencies, and symlinks configs:

```sh
sh install.sh -f
```

### 2. Install runtimes

```sh
mise use -g node@lts
mise use -g python@3.12
mise use -g go@latest
```

Rust is managed separately via [rustup](https://www.rust-lang.org/tools/install):
```sh
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
```

### 3. Options

```sh
# Full install: packages + dependency check + symlinks
sh install.sh -f

# Preview what will happen
sh install.sh --dry-run

# Skip package install (just symlink)
sh install.sh -f --skip-packages

# Uninstall (remove symlinks only)
sh install.sh --uninstall
```

| Flag | Description |
|------|-------------|
| `-f` | Force mode. Backs up existing files to `~/.dotfiles-backup/` and overwrites. |
| `-q` | Quiet mode. Suppresses console output. |
| `--dry-run` | Show what would happen without making changes. |
| `--uninstall` | Remove symlinks created by this script. |
| `--skip-packages` | Skip the package installation step. |
| `--home <dir>` | Custom home directory (default: `~`) |
| `--config <dir>` | Custom config directory (default: `~/.config`) |

### 4. First launch

**Shell:** antidote auto-clones plugins on first launch. mise activates runtimes.

**Neovim:** lazy.nvim bootstraps, plugins install, Mason installs LSP servers and formatters.

## Structure

```
dotfiles/
├── packages/
│   ├── install.sh       # OS-aware package installer
│   ├── Brewfile         # macOS packages
│   └── apt.txt          # Ubuntu/Debian packages
├── zsh/
│   ├── .zshenv          → ~/.zshenv
│   ├── .zshrc           → ~/.config/zsh/.zshrc
│   ├── zsh_plugins.txt  → ~/.config/zsh/zsh_plugins.txt
│   └── zsh.d/           → ~/.config/zsh/zsh.d/
├── nvim/                → ~/.config/nvim/
├── kitty/               → ~/.config/kitty/
├── starship/
│   └── starship.toml    → ~/.config/starship.toml
└── install.sh           # Symlink installer
```

## Machine-Specific Config

Files matching `*custom.*` and `*secret.*` in `zsh/zsh.d/` are gitignored. Use these for machine-specific environment variables, paths, and credentials.

## Updating the Brewfile

After installing new packages via brew:

```sh
brew bundle dump --describe --force --file=packages/Brewfile
```
