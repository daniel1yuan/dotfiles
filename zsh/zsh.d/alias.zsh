# Aliases
alias reload='source "$ZDOTDIR/.zshrc"'
alias cmain="git checkout main"
alias pmain="git pull origin main"

# Git Aliases
alias gs="git status"
alias gc="git checkout"
alias gp="git pull"
alias gph="git pull origin HEAD"

# Kitty SSH with terminfo support
alias kssh="kitty +kitten ssh"

# Secrets management (sops + age)
secrets-edit() {
  local target="${1:-$HOME/.secrets/env/global.env}"
  if [[ ! -f "$SOPS_AGE_KEY_FILE" ]]; then
    echo "No age key found at $SOPS_AGE_KEY_FILE" >&2
    echo "Run: sh ~/Projects/dotfiles/secrets/setup.sh" >&2
    return 1
  fi
  if [[ ! -f "$target" ]]; then
    echo "Creating new encrypted file: $target"
  fi
  sops "$target"
}

secrets-show() {
  local target="${1:-$HOME/.secrets/env/global.env}"
  if [[ ! -f "$target" ]]; then
    echo "No secrets file at $target" >&2
    return 1
  fi
  sops -d "$target"
}

# Modern CLI replacements
alias ls='eza --icons --group-directories-first'
alias ll='eza -la --icons --group-directories-first --git'
alias lt='eza --tree --level=2 --icons'
alias cat='bat --paging=never'
