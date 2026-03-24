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

# Platform-aware ls color
if [[ "$(uname)" == "Darwin" ]]; then
  alias ls='ls -G'
else
  alias ls='ls --color=auto'
fi
