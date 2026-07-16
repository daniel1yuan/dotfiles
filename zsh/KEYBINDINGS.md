# zsh keybindings

Summon anytime with `keys` (fuzzy-searchable). Mirrors the nvim control scheme.

## Command mode (press Esc first)

`h` `l` — left / right one char
`w` `b` `e` — next / prev / end of word (`W` `B` `E` = WORD, whitespace-delimited)
`0` `^` `$` — line start / first non-blank / line end
`f{c}` `t{c}` `F{c}` `T{c}` — jump to / before a char; `;` `,` repeat / reverse
`%` — jump to matching bracket
`gg` `G` — start of buffer / fetch history entry by number
`c` `d` `y` + motion — change / delete / yank (e.g. `dw`, `d$`, `y%`)
`C` `D` `S` — change / kill to end of line / change whole line
`x` `r{c}` `~` — delete char / replace char / swap case
`p` `P` — put (paste) after / before
`u` `Ctrl-R` — undo / redo
`.` — repeat last change
`v` `V` — visual / visual-line mode
`>` `<` `J` — indent / unindent / join lines
`i` `a` `I` `A` `o` `O` — enter insert: here / after / bol / eol / below / above

## Insert mode (Ctrl keys)

`Ctrl-A` `Ctrl-E` — jump to line start / end
`Ctrl-W` — delete previous word
`Ctrl-K` `Ctrl-U` — kill to end / start of line
`Ctrl-R` — fuzzy history search (fzf)
`Right` `Ctrl-E` — accept the gray autosuggestion
`Tab` — open the completion menu (fzf-tab)
`Up` `Down` — history substring search (also works in command mode)

## fzf menus (completion, Ctrl-R, Ctrl-T, Alt-C)

`Ctrl-J` `Ctrl-K` — move down / up (also `Ctrl-N` `Ctrl-P`, arrows)
`Ctrl-Y` `Enter` — accept the selection
`Ctrl-U` `Ctrl-D` — scroll preview half-page
`Ctrl-B` `Ctrl-F` — scroll preview full page
`Esc` `Ctrl-C` — cancel

## fzf shortcuts

`Ctrl-R` — command history
`Ctrl-T` — insert a file path
`Alt-C` — cd into a directory (macOS: needs ghostty `macos-option-as-alt = true`, else Option-C types ç)
