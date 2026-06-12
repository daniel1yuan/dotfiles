# Dotfiles

Personal dotfiles for zsh, neovim, kitty, and starship. XDG-compliant where possible.

## What's Configured

| Tool | Config | What it does |
|------|--------|-------------|
| **zsh** | `zsh/` | Shell with [antidote](https://antidote.sh/) plugins, modular config via `zsh.d/` |
| **neovim** | `nvim/` | Editor with [lazy.nvim](https://github.com/folke/lazy.nvim) plugins, LSP, treesitter, telescope |
| **kitty** | `kitty/` | Terminal emulator (optional) with custom keybindings and theme |
| **ghostty** | `ghostty/` | Terminal emulator (optional), mirrors the kitty setup |
| **starship** | `starship/` | Minimal cross-shell prompt (directory, git, command duration) |
| **lazygit** | `lazygit/` | Git TUI with catppuccin theme, opens in nvim via `<leader>gg` |
| **git** | `git/` | Sane defaults (rebase pulls, rerere, zdiff3) with [delta](https://github.com/dandavison/delta) diffs. Identity lives in `~/.gitconfig.local` per machine |
| **mise** | via zsh | Runtime version manager for node, python, go |
| **secrets** | `secrets/` | Secrets management with [sops](https://github.com/getsops/sops) + [age](https://github.com/FiloSottile/age) (optional) |

### Shell tools (initialized in zsh config)

| Tool | What it does |
|------|-------------|
| fzf | Fuzzy finder. Ctrl-R (history), Ctrl-T (files), Alt-C (directories) |
| fd | Fast file finder. Powers fzf and telescope |
| bat | Syntax-highlighted cat. Powers fzf file previews |
| eza | ls replacement with git status, icons, tree view |
| zoxide | Smarter cd. `z dot` jumps to ~/Projects/dotfiles |
| ripgrep | Fast recursive grep. Powers telescope live grep |
| lazygit | Terminal UI for git. `lg` in the shell, `<leader>gg` in nvim |

## Setup

### 1. Install dotfiles

Installs packages, checks dependencies, and symlinks configs:

```sh
sh install.sh -f
```

### 2. Install runtimes

Neovim's language-dependent LSPs (typescript, vue, json/yaml, pyright, ruff) only activate when their runtime is installed. To install node + python (and mise itself, if missing) in one step:

```sh
sh packages/runtimes.sh
```

Then reopen nvim and Mason installs the servers automatically. Or install runtimes individually:

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

### 4. Secrets (optional)

If you need encrypted environment variables or other secrets on this machine:

```sh
sh secrets/setup.sh
```

This sets up `~/.secrets/` with an age key and sops config. See [`secrets/README.md`](secrets/README.md) for the full workflow (adding machines, editing secrets, per-project secrets via direnv).

The secrets directory syncs manually across machines (same as your KeePass db). The dotfiles install script doesn't touch `~/.secrets/` in any way.

### 5. First launch

**Shell:** antidote auto-clones plugins on first launch. mise activates runtimes.

**Neovim:** lazy.nvim bootstraps, plugins install, Mason installs LSP servers and formatters.

## Structure

```
dotfiles/
├── packages/
│   ├── install.sh       # OS-aware package installer
│   ├── runtimes.sh      # node + python via mise (enables nvim LSPs)
│   ├── nvim.sh          # latest stable neovim to ~/.local (Linux)
│   ├── Brewfile         # macOS packages
│   └── apt.txt          # Ubuntu/Debian packages
├── zsh/
│   ├── .zshenv          → ~/.zshenv
│   ├── .zshrc           → ~/.config/zsh/.zshrc
│   ├── zsh_plugins.txt  → ~/.config/zsh/zsh_plugins.txt
│   └── zsh.d/           → ~/.config/zsh/zsh.d/
├── nvim/                → ~/.config/nvim/
├── kitty/               → ~/.config/kitty/
├── ghostty/             → ~/.config/ghostty/
├── git/                 → ~/.config/git/
├── lazygit/             → ~/.config/lazygit/
├── starship/
│   └── starship.toml    → ~/.config/starship.toml
├── secrets/
│   ├── setup.sh         # Sets up ~/.secrets/ (never overwrites)
│   └── README.md        # Secrets management docs
└── install.sh           # Symlink installer
```

## Machine-Specific Config

Files matching `*custom.*` and `*secret.*` in `zsh/zsh.d/` are gitignored. Use these for machine-specific environment variables, paths, and credentials.

## Updating the Brewfile

After installing new packages via brew:

```sh
brew bundle dump --describe --force --file=packages/Brewfile
```
