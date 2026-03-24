# Zsh

XDG-compliant zsh configuration using `ZDOTDIR`.

## How It Works

`~/.zshenv` sets `ZDOTDIR=~/.config/zsh`, which tells zsh to look for `.zshrc` there instead of `$HOME`. The `.zshrc` auto-sources all `*.zsh` files from `zsh.d/`.

## Plugins (via zplug)

zplug auto-clones to `~/.local/share/zplug/` on first launch.

| Plugin | Purpose |
|--------|---------|
| zsh-completions | Additional shell completions |
| zsh-history-substring-search | Type and search through history |
| zsh-autosuggestions | Fish-like suggestions as you type |
| zsh-syntax-highlighting | Command syntax highlighting |
| alien | Prompt theme (soft variant) |
| zsh-nvm | Lazy-loaded NVM for Node.js version management |

## Modular Config (`zsh.d/`)

| File | Contents |
|------|----------|
| `alias.zsh` | Git aliases (`gs`, `gc`, `gp`), navigation, reload |
| `env.zsh` | Editor, PATH, prompt theme, NVM config, encryption key paths |
| `functions.zsh` | Encryption/decryption, `pruneBranches`, `pullHead`, `kssh` |
| `*custom.*` | Machine-specific config (gitignored) |
| `*secret.*` | Secrets and credentials (gitignored) |

## NVM Lazy Loading

NVM lazy loads in interactive shells for faster startup. In non-interactive shells (CI, Claude Code, scripts), NVM loads eagerly so `node`/`npm` are immediately available.

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
| `kssh` | SSH with kitty terminfo support |
| `ls` | Platform-aware colored ls (macOS `-G`, Linux `--color=auto`) |

## Key Functions

| Function | Description |
|----------|-------------|
| `encrypt <file>` | RSA-encrypt a file with public key |
| `encryptFile <file>` | Encrypt large files (AES-256 + RSA key wrapping) |
| `decrypt <file>` | RSA-decrypt a file with private key |
| `decryptFile <file>` | Decrypt large files |
| `pruneBranches` | Interactive cleanup of merged git branches |
| `pullHead` | Pull current branch from origin |
