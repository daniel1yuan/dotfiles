# Antidote plugin manager
ANTIDOTE_HOME="${XDG_DATA_HOME:-$HOME/.local/share}/antidote"

if [[ ! -d "$ANTIDOTE_HOME" ]]; then
  git clone --depth=1 https://github.com/mattmc3/antidote.git "$ANTIDOTE_HOME" || { echo "Failed to clone antidote"; return 1; }
fi

source "$ANTIDOTE_HOME/antidote.zsh"
antidote load "$ZDOTDIR/zsh_plugins.txt"

# Completions: must run after antidote (plugins add to fpath) and before zsh.d
# (tool inits like mise/zoxide call compdef). The dump is cached in XDG cache;
# the full security audit only reruns when the dump is older than 24h.
autoload -Uz compinit
_zcompdump="${XDG_CACHE_HOME:-$HOME/.cache}/zsh/zcompdump"
mkdir -p "${_zcompdump:h}"
_zcompdump_stale=(${_zcompdump}(N.mh+24))
if [[ ! -f "$_zcompdump" ]] || (( ${#_zcompdump_stale} )); then
  compinit -d "$_zcompdump"
else
  compinit -C -d "$_zcompdump"
fi
unset _zcompdump _zcompdump_stale
zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}'

# fzf-tab: fuzzy menu for tab completion. The plugin loads before compinit
# (via antidote above), so it has to be enabled here, after compinit has run.
if (( $+functions[enable-fzf-tab] )); then
  enable-fzf-tab
  # Make the completion menu honor FZF_DEFAULT_OPTS (nvim-style keys + header).
  zstyle ':fzf-tab:*' use-fzf-default-opts yes
  zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza --tree --level=1 --icons $realpath'
fi

# Load all files from zsh.d directory
if [[ -d "$ZDOTDIR/zsh.d" ]]; then
  for file in "$ZDOTDIR/zsh.d"/*.zsh; do
    source "$file"
  done
fi
