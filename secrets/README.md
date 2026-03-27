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
│   └── global.env  # sops-encrypted env vars, sourced at shell init
├── keys/
│   └── *.pem       # TLS/service keys
└── db/
    └── *.kdbx      # KeePass databases
```

## Setup

### Prerequisites

```sh
# macOS
brew install age sops

# Linux (via mise)
mise use -g age@latest sops@latest
```

### First-time setup

```sh
sh ~/Projects/dotfiles/secrets/setup.sh
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

| Command | What it does |
|---------|-------------|
| `secrets-edit` | Edit the global secrets file |
| `secrets-edit ~/.secrets/env/project.env` | Edit a specific secrets file |
| `secrets-show` | Print decrypted global secrets to stdout |

The global secrets file is automatically sourced at shell startup if sops and the file both exist. If either is missing, it's a no-op.

## Adding a new machine

1. Run `sh secrets/setup.sh` on the new machine
2. Copy the public key it prints (starts with `age1...`)
3. On any existing machine, add the new key to `~/.secrets/.sops.yaml`
4. Re-encrypt so the new machine can decrypt:
   ```sh
   sops updatekeys ~/.secrets/env/global.env
   ```
5. Sync the updated `.sops.yaml` and `.env` files to the new machine (the `age/keys.txt` stays local)

## Per-project secrets with direnv

For secrets scoped to a specific project, create a separate env file and source it in a `.envrc`:

```sh
# Create the encrypted file
secrets-edit ~/.secrets/env/myproject.env

# In the project's .envrc
eval "$(sops -d ~/.secrets/env/myproject.env 2>/dev/null)"
```

## Safety

- `setup.sh` never overwrites existing files or directories
- `setup.sh` never deletes anything
- The dotfiles `install.sh` doesn't touch `~/.secrets/` in any way (and never will)
- Uninstalling dotfiles doesn't affect secrets
- Plaintext only exists in memory during shell sessions
