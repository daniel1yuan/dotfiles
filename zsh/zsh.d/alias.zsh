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

# Modern CLI replacements
alias ls='eza --icons --group-directories-first'
alias ll='eza -la --icons --group-directories-first --git'
alias lt='eza --tree --level=2 --icons'
alias cat='bat --paging=never'
