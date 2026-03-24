# Load all files from zsh.d directory
if [[ -d "$ZDOTDIR/zsh.d" ]]; then
  for file in "$ZDOTDIR/zsh.d"/*.zsh; do
    source "$file"
  done
fi

# Zplug Configuration
export ZPLUG_HOME="${XDG_DATA_HOME:-$HOME/.local/share}/zplug"

if [[ ! -d "$ZPLUG_HOME" ]]; then
  git clone https://github.com/zplug/zplug "$ZPLUG_HOME"
fi

if [[ -f "$ZPLUG_HOME/init.zsh" ]]; then
  source "$ZPLUG_HOME/init.zsh"

  # Plugins
  zplug 'zplug/zplug', hook-build:'zplug --self-manage'
  zplug 'zsh-users/zsh-completions'
  zplug 'zsh-users/zsh-history-substring-search'
  zplug 'zsh-users/zsh-autosuggestions'
  zplug 'zsh-users/zsh-syntax-highlighting', defer:2
  zplug "eendroroy/alien"
  zplug "lukechilds/zsh-nvm"

  # Load Plugins
  zplug load

  # Install all uninstalled plugins
  if ! zplug check; then
    zplug install
  fi
fi

# Completions
zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}'
