# Alien Prompt Configuration
export ALIEN_THEME="soft"

# Zsh Autosuggestion configuration
export ZSH_AUTOSUGGEST_USE_ASYNC=1

export PATH=~/.local/bin:$PATH

# Environment Context
export EDITOR=nvim

# Zsh nvm plugin: lazy load in interactive shells, eager load otherwise
# Non-interactive shells (CI, Claude Code, scripts) need node/npm available immediately
if [[ -o interactive ]]; then
  export NVM_LAZY_LOAD=true
else
  export NVM_LAZY_LOAD=false
fi

