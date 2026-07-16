# Pin XDG config explicitly so tools that default elsewhere on macOS
# (e.g. lazygit's ~/Library/Application Support) read ~/.config instead
export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
export ZDOTDIR="$XDG_CONFIG_HOME/zsh"

# mise shims for non-interactive shells (CI, Claude Code, scripts).
# Interactive shells get full activation in env.zsh instead.
if [[ ! -o interactive ]]; then
  eval "$(mise activate zsh --shims)" 2>/dev/null
fi

# rustup/cargo (only on machines where it's installed)
[[ -f "$HOME/.cargo/env" ]] && . "$HOME/.cargo/env"
