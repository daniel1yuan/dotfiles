# Zsh

XDG-compliant zsh configuration using `ZDOTDIR`.

## How It Works

`~/.zshenv` sets `ZDOTDIR=~/.config/zsh`, which tells zsh to look for `.zshrc` there instead of `$HOME`. The `.zshrc` auto-sources all `*.zsh` files from `zsh.d/`.

## Plugins (via antidote)

antidote auto-clones to `~/.local/share/antidote/` on first launch. Plugins are declared in `zsh_plugins.txt`.

| Plugin | Purpose |
|--------|---------|
| zsh-completions | Additional shell completions |
| zsh-history-substring-search | Type and search through history |
| zsh-autosuggestions | Fish-like suggestions as you type |
| zsh-syntax-highlighting | Command syntax highlighting |

Prompt is [starship](https://starship.rs/), initialized in `env.zsh`. Config lives in `starship/starship.toml`.

## Modular Config (`zsh.d/`)

| File | Contents |
|------|----------|
| `alias.zsh` | Git aliases (`gs`, `gc`, `gp`), navigation, reload |
| `env.zsh` | Editor, PATH, prompt theme, mise activation, tool config |
| `functions.zsh` | Encryption/decryption, `pruneBranches`, `pullHead`, `kssh` |
| `*custom.*` | Machine-specific config (gitignored) |
| `*secret.*` | Secrets and credentials (gitignored) |

## Shell Tools

Initialized in `env.zsh`. Install via `sh packages/install.sh` (handles macOS and Ubuntu).

| Tool | What it does |
|------|-------------|
| fzf | Fuzzy finder. Ctrl-R (history), Ctrl-T (files), Alt-C (directories) |
| fd | Fast file finder. Powers fzf's Ctrl-T and Alt-C |
| bat | Syntax-highlighted cat. Also powers fzf file previews |
| eza | ls replacement with git status, icons, tree view |
| zoxide | Smarter cd. `z dot` jumps to ~/Projects/dotfiles |
| ripgrep | Fast recursive grep. Used by telescope in nvim |

## Runtime Management (mise)

[mise](https://mise.jdx.dev/) manages runtime versions (node, python, go). Two-layer activation:
- **`.zshenv`**. Shims mode. Tools available in all shells, including non-interactive (CI, Claude Code, scripts).
- **`env.zsh`**. Full activation for interactive shells. Dynamic version switching, env vars from `mise.toml`.

Install runtimes with `mise use -g node@lts`, `mise use -g python@3.12`, etc. Per-project versions via `mise.toml` or `.tool-versions` in the project root.

## Key Aliases

| Alias | Command |
|-------|---------|
| `gs` | `git status` |
| `gc` | `git checkout` |
| `gp` | `git pull` |
| `gph` | `git pull origin HEAD` |
| `cmain` | `git checkout main` |
| `pmain` | `git pull origin main` |
| `reload` | Re-source `.zshrc` |
| `lg` | `lazygit` |
| `kssh` | SSH with kitty terminfo support |
| `ls` | `eza` with icons, directories first |
| `ll` | `eza` long listing with git status |
| `lt` | `eza` tree view (2 levels deep) |
| `cat` | `bat` with syntax highlighting |

## Key Functions

| Function | Description |
|----------|-------------|
| `encrypt <file>` | RSA-encrypt a file with public key |
| `encryptFile <file>` | Encrypt large files (AES-256 + RSA key wrapping) |
| `decrypt <file>` | RSA-decrypt a file with private key |
| `decryptFile <file>` | Decrypt large files |
| `pruneBranches` | Interactive cleanup of merged git branches |
| `pullHead` | Pull current branch from origin |
