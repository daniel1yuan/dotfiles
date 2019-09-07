# Load all files from .shell/zshrc.d directory
if [ -d $HOME/.zsh.d ]; then
  for file in $HOME/.zsh.d/*.zsh; do
    source $file
  done
fi

# Zplug Configuration
source ~/.zplug/init.zsh

# Plugins
zplug 'zplug/zplug', hook-build:'zplug --self-manage'
zplug 'zsh-users/zsh-completions'
zplug 'zsh-users/zsh-history-substring-search'
zplug 'zsh-users/zsh-autosuggestions'
zplug 'zsh-users/zsh-syntax-highlighting', defer:2
zplug "eendroroy/alien"

# Load Plugins
zplug load

# Install all uninstalled plugins
if ! zplug check; then
  zplug install
fi

# Completions
zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}'
