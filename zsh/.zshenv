export ZDOTDIR="${XDG_CONFIG_HOME:-$HOME/.config}/zsh"

# mise shims for non-interactive shells (CI, Claude Code, scripts).
# Interactive shells get full activation in env.zsh instead.
if [[ ! -o interactive ]]; then
  eval "$(mise activate zsh --shims)" 2>/dev/null
fi
