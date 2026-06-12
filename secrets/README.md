# Secrets Management

We use [sops](https://github.com/getsops/sops) + [age](https://github.com/FiloSottile/age) for encrypting secrets. Cross-platform, no external services, no plaintext files sitting around.

## How it works

- **age** is the encryption backend. Each machine gets its own public/private key pair.
- **sops** wraps age with a nice editing workflow: it decrypts to your `$EDITOR`, you make changes, and it re-encrypts on save. You never touch encrypted content directly.
- Secrets are encrypted for one or more machine public keys, so any of those machines can decrypt them.
- The encrypted files live in `~/.secrets/` and are never committed to this repo.

## Directory structure

```
~/.secrets/
├── .sops.yaml      # which age public keys can decrypt (syncs across machines)
├── age/
│   └── keys.txt    # this machine's private key (never leaves this machine)
├── env/
│   ├── global.env  # sops-encrypted, sourced at shell init
│   └── *.env       # any .env file here gets sourced automatically
├── keys/
│   └── *.pem       # TLS/service keys
└── db/
    └── *.kdbx      # KeePass databases
```

## Setup

### Prerequisites

```sh
# Should be auto-installed already by dotfiles package setup.sh

# macOS
brew install age sops

# Linux (via mise)
mise use -g age@latest sops@latest
```

### First-time setup

```sh
sh secrets/setup.sh
```

This creates the `~/.secrets/` directory structure, generates an age key, and writes the initial `.sops.yaml`. If any of those already exist, it skips them. The script never overwrites or deletes anything.

### Create your first encrypted env file

```sh
secrets-edit
```

This opens your `$EDITOR` with a blank file. Add entries like:

```sh
export AWS_ACCESS_KEY_ID="AKIA..."
export AWS_SECRET_ACCESS_KEY="..."
export GITLAB_TOKEN="glpat-..."
```

Save and close. sops handles the encryption.

## Daily usage

### Shell helpers

These are defined in the dotfiles zsh config and available in any shell session.

| Command                                    | What it does                               |
| ------------------------------------------ | ------------------------------------------ |
| `secrets-edit`                             | Edit `~/.secrets/env/global.env` (default) |
| `secrets-edit ~/.secrets/env/<custom>.env` | Edit (or create) a specific secrets file   |
| `secrets-show`                             | Print decrypted `global.env` to stdout     |
| `secrets-show ~/.secrets/env/<custom>.env` | Print a specific decrypted file to stdout  |

Both commands validate that your age key exists before doing anything. If the file doesn't exist yet, `secrets-edit` creates a new encrypted file.

### Auto-sourcing

All `.env` files in `~/.secrets/env/` are automatically sourced at shell startup. Just drop a new encrypted file in the directory and it gets picked up on next shell init. If sops isn't installed or the directory is empty, it's a no-op. If a file fails to decrypt (corrupt, unencrypted, etc.), you'll get a warning instead of a silent skip.

### Environment variables

The age key and sops config paths are passed to sops **per-invocation** by the zsh helpers (`secrets-edit`, `secrets-show`, and the auto-sourcing loop). They are deliberately NOT exported globally, so other sops usage on the machine (work repos with their own `.sops.yaml` or key material) is unaffected by this setup.

| Setting             | Value                     | Purpose                                 |
| ------------------- | ------------------------- | --------------------------------------- |
| `SOPS_AGE_KEY_FILE` | `~/.secrets/age/keys.txt` | Tells sops where the age private key is |
| `--config`          | `~/.secrets/.sops.yaml`   | Tells sops where the creation rules are |

If you run `sops` manually against `~/.secrets/` files, pass these yourself:

```sh
SOPS_AGE_KEY_FILE=~/.secrets/age/keys.txt sops --config ~/.secrets/.sops.yaml updatekeys ~/.secrets/env/global.env
```

## Adding a new machine

1. Run `sh secrets/setup.sh` on the new machine
2. Copy the public key it prints (starts with `age1...`)
3. On any existing machine, add the new key to `~/.secrets/.sops.yaml`
4. Re-encrypt so the new machine can decrypt:
   ```sh
   sops updatekeys ~/.secrets/env/global.env
   ```
5. Sync the updated `.sops.yaml` and `.env` files to the new machine (the `age/keys.txt` stays local)

## Important: everything in `env/` is global

All `.env` files in `~/.secrets/env/` are sourced into every shell session. Don't put project-scoped secrets here. For project-specific secrets, use a local `.env` file in the project directory (gitignored).

## Safety

- `setup.sh` never overwrites existing files or directories
- `setup.sh` never deletes anything
- The dotfiles `install.sh` doesn't touch `~/.secrets/` in any way
- Uninstalling dotfiles doesn't affect secrets
- Plaintext only exists in memory during shell sessions
