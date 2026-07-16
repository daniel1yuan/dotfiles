# Fuzzy-searchable keybinding cheatsheet. Reads KEYBINDINGS.md (the single source
# of truth) and pipes it through fzf.
keys() {
  local cheat="${ZDOTDIR:-$HOME/.config/zsh}/KEYBINDINGS.md"
  if [[ ! -r $cheat ]]; then
    print -u2 "keys: cheatsheet not found at $cheat"
    return 1
  fi
  if ! (( $+commands[fzf] )); then
    ${PAGER:-less} "$cheat"
    return
  fi
  if (( $+commands[bat] )); then
    fzf --ansi --reverse --prompt='keys> ' \
      < <(bat --color=always --style=plain --language=markdown "$cheat")
  else
    fzf --reverse --prompt='keys> ' < "$cheat"
  fi
}
