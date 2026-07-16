# Native vi mode for the command line, tuned to match the user's nvim controls.
# Editing uses zsh's built-in vi keymaps (no plugin); insert mode stays forgiving.
# Sourced last among zsh.d/*.zsh (alphabetically after env.zsh), so nothing
# re-links the keymap afterward.

# Make vi mode explicit (it was implicit via EDITOR=nvim).
bindkey -v

# Near-instant Escape into command mode. Native zsh has a single timeout knob
# (hundredths of a second, default 40), so g-prefixed combos (gg, gU, g~) must be
# typed briskly. Raise to ~20 if that misfires. Local terminals only; can be
# flaky over high-latency SSH.
KEYTIMEOUT=1

# --- Cursor shape per mode (beam in insert, block in command) -----------------
# add-zle-hook-widget appends handlers, so this coexists with zsh-autosuggestions
# and the starship transient-prompt handler instead of clobbering them.
autoload -Uz add-zle-hook-widget

_vimmode_cursor_beam()  { print -n '\e[6 q' }   # insert
_vimmode_cursor_block() { print -n '\e[2 q' }   # command

_vimmode_cursor_select() {
  case $KEYMAP in
    vicmd)      _vimmode_cursor_block ;;
    main|viins) _vimmode_cursor_beam ;;
  esac
}
_vimmode_cursor_init()   { _vimmode_cursor_beam }
_vimmode_cursor_finish() { _vimmode_cursor_beam }

add-zle-hook-widget keymap-select _vimmode_cursor_select
add-zle-hook-widget line-init     _vimmode_cursor_init
add-zle-hook-widget line-finish   _vimmode_cursor_finish

# --- Forgiving insert mode ----------------------------------------------------
# Native vi-insert leaves these as self-insert; restore the universal shell keys.
# ^E -> end-of-line also re-enables Ctrl-E to accept the autosuggestion.
bindkey -M viins '^A' beginning-of-line
bindkey -M viins '^E' end-of-line
bindkey -M viins '^K' kill-line
# ^U's vi default (vi-kill-line) only kills back to where insert mode began;
# make it the universal kill-to-line-start instead.
bindkey -M viins '^U' backward-kill-line

# --- History substring search (both keymaps) ----------------------------------
# Type a prefix, then Up/Down to cycle matches; works in insert and command mode.
# Native j/k in vicmd stay as plain history up/down.
for _km in viins vicmd; do
  bindkey -M "$_km" '^[[A' history-substring-search-up
  bindkey -M "$_km" '^[OA' history-substring-search-up
  bindkey -M "$_km" '^[[B' history-substring-search-down
  bindkey -M "$_km" '^[OB' history-substring-search-down
done
unset _km

# --- Redo in command mode ------------------------------------------------------
# fzf --zsh (sourced in env.zsh, before this file) binds ^R in vicmd to its
# history widget, which would shadow redo. Command mode gets redo (matching
# nvim); fuzzy history search stays on ^R in insert mode.
bindkey -M vicmd '^R' redo
