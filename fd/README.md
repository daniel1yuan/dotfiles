# fd

Global always-ignore list for [fd](https://github.com/sharkdp/fd), the file finder that powers fzf's Ctrl-T and telescope's `<leader>sf`/`<leader>sF` in nvim.

`ignore` is symlinked to `~/.config/fd/ignore` by `install.sh` and uses gitignore syntax. Anything listed there (`.git`, `node_modules`) never shows up in fd results, even in "search everything" modes that bypass `.gitignore`.

## How the ignore layers interact

| Invocation | `.gitignore` | This list |
|------------|--------------|-----------|
| `fd` (default) | respected | respected |
| `fd --no-ignore-vcs` (nvim's `<leader>sF`) | bypassed | respected |
| `fd --no-ignore` / `fd -u` | bypassed | bypassed |

This is what makes `<leader>sF` useful for browsing gitignored specs and design docs: it drops the gitignore rules but keeps the junk list.

## Adding an entry

Add a line to `ignore`, then mirror it in the sibling lists:

- [ripgrep/config](../ripgrep/config) for grep (`--glob=!name/`)
- `filters.custom` in [nvim-tree.lua](../nvim/lua/danielyuan/lazy/nvim-tree.lua) for the file tree

For a one-off exclusion in a single project, drop a `.fdignore` (fd only) or `.ignore` (fd and ripgrep) file in that project instead of growing the global list.

## Upstream docs

- `man fd`, FILES section, documents the global ignore file location
- [fd README: excluding files](https://github.com/sharkdp/fd#excluding-specific-files-or-directories)
