# Copy-command helpers — capture a command + its output to the clipboard.
#
# Use case: running a command and handing the result back to an LLM (Claude)
# without leaving the keyboard. Ghostty 1.3.1 has no keybind that copies a
# command+output block (its semantic selection only fires on cmd+triple-click),
# so this lives in the shell instead, where it can grab clean text.
#
#   c npm test       runs `npm test`, shows output live, and copies:
#                        $ npm test
#                        <full output>
#   c+ git status    runs the command and APPENDS its block to the clipboard,
#                    so several command+output pairs stack into one paste.
#
# Notes:
#   - Output is piped through `tee`, so the command's stdout is not a TTY and
#     most tools auto-disable color. Any ANSI codes that slip through are
#     stripped before copying, keeping the clipboard plain-text for pasting.
#   - A nonzero exit appends a `# exit N` line so the failure is visible too.
#   - Aliases work (the command is re-parsed via `eval`).
#   - Avoid wrapping interactive programs (vim, less, ssh) — the pipe to `tee`
#     breaks their TTY handling. This is for capturing command output.

# Pick clipboard commands: macOS (pbcopy/pbpaste), else Wayland, else X11.
if (( $+commands[pbcopy] )); then
  _cc_copy()  { pbcopy }
  _cc_paste() { pbpaste }
elif (( $+commands[wl-copy] )); then
  _cc_copy()  { wl-copy }
  _cc_paste() { wl-paste 2>/dev/null }
elif (( $+commands[xclip] )); then
  _cc_copy()  { xclip -selection clipboard }
  _cc_paste() { xclip -selection clipboard -o 2>/dev/null }
fi

_cc_run() {
  if ! typeset -f _cc_copy >/dev/null; then
    echo "c: no clipboard tool found (need pbcopy, wl-copy, or xclip)" >&2
    return 1
  fi

  local mode="$1"; shift
  if (( $# == 0 )); then
    echo "usage: c <command>   ('c+' appends to the current clipboard)" >&2
    return 2
  fi

  # Reconstruct the typed command line with correct quoting for display + eval.
  local cmd="${(j: :)${(q-)@}}"

  local tmp rc output
  tmp="$(mktemp)" || return 1
  {
    eval "$cmd" 2>&1 | tee "$tmp"
    rc=$pipestatus[1]

    # Strip escape sequences (OSC titles/hyperlinks, CSI colors/cursor, then
    # stray two-char escapes) so the clipboard stays plain text. Without perl,
    # copy the capture raw rather than not at all.
    if (( $+commands[perl] )); then
      output="$(perl -pe 's/\e\][^\a\e]*(?:\a|\e\\)?//g; s/\e\[[0-9;?]*[ -\/]*[@-~]//g; s/\e.//g' "$tmp")"
    else
      output="$(<"$tmp")"
    fi
  } always {
    # Runs even if the command is interrupted, so captured output (which can
    # include credentials) never lingers in /tmp.
    rm -f "$tmp"
  }

  local block="\$ ${cmd}"$'\n'"${output}"
  (( rc != 0 )) && block+=$'\n'"# exit ${rc}"

  if [[ "$mode" == append ]]; then
    # Read the clipboard before piping into the copy tool; reading it inside
    # the same pipeline races with the overwrite on some clipboard backends.
    local prev; prev="$(_cc_paste)"
    if [[ -n "$prev" ]]; then
      printf '%s\n\n%s\n' "$prev" "$block" | _cc_copy
    else
      printf '%s\n' "$block" | _cc_copy
    fi
  else
    printf '%s\n' "$block" | _cc_copy
  fi

  return $rc
}

c()    { _cc_run reset  "$@" }
"c+"() { _cc_run append "$@" }
