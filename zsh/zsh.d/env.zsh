# Zsh Autosuggestion configuration
export ZSH_AUTOSUGGEST_USE_ASYNC=1

export PATH=~/.local/bin:$PATH

# Environment Context
export EDITOR=nvim

# mise: full activation for interactive shells (dynamic version switching, env vars)
# Shims fallback for non-interactive shells is in .zshenv
eval "$(mise activate zsh)"

# fzf: use fd for file/directory search (respects .gitignore)
export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND='fd --type d --hidden --follow --exclude .git'
export FZF_CTRL_T_OPTS="--preview 'bat --color=always --line-range=:200 {}'"
export FZF_ALT_C_OPTS="--preview 'eza --tree --level=1 --icons {}'"

# fzf keybindings and completion (Ctrl-R, Ctrl-T, Alt-C)
source <(fzf --zsh)

# zoxide (smarter cd)
eval "$(zoxide init zsh)"

# Starship prompt
eval "$(starship init zsh)"

# Transient prompt: collapse previous prompts to just the prompt character
starship_transient_prompt_func() {
  starship module character
}

starship_transient_accept_line() {
  local saved_prompt="$PROMPT"
  local saved_rprompt="$RPROMPT"
  PROMPT="$(starship_transient_prompt_func) "
  RPROMPT=""
  zle reset-prompt
  PROMPT="$saved_prompt"
  RPROMPT="$saved_rprompt"
  zle .accept-line
}

zle -N accept-line starship_transient_accept_line

