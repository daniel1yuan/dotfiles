# Load all files from zsh.d directory
if [[ -d "$ZDOTDIR/zsh.d" ]]; then
  for file in "$ZDOTDIR/zsh.d"/*.zsh; do
    source "$file"
  done
fi

# Antidote plugin manager
ANTIDOTE_HOME="${XDG_DATA_HOME:-$HOME/.local/share}/antidote"

if [[ ! -d "$ANTIDOTE_HOME" ]]; then
  git clone --depth=1 https://github.com/mattmc3/antidote.git "$ANTIDOTE_HOME"
fi

source "$ANTIDOTE_HOME/antidote.zsh"
antidote load "$ZDOTDIR/zsh_plugins.txt"

# Completions
zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}'
