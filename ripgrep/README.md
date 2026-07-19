# ripgrep

Always-ignore globs for [ripgrep](https://github.com/BurntSushi/ripgrep), which powers telescope's `<leader>sg`/`<leader>sG` and grug-far in nvim, plus plain `rg` in the shell.

Ripgrep has no default config location; it reads whatever file `RIPGREP_CONFIG_PATH` points to. That variable is exported in [zsh/zsh.d/env.zsh](../zsh/zsh.d/env.zsh), targeting `~/.config/ripgrep/config`, which `install.sh` symlinks to `config` in this directory.

The format is one flag per line, `#` for comments. The current contents exclude `.git` and `node_modules` from every search via `--glob=!name/` rules.

## Behavior notes

- The config applies to every rg run, but explicitly named paths are always searched: `rg foo node_modules/x.js` still works.
- nvim's `<leader>sG` runs `rg --hidden --no-ignore-vcs`, which bypasses `.gitignore` (so gitignored specs and drafts are searchable) while these globs still apply.
- To run rg with no config at all: `rg --no-config ...`
- For a one-off exclusion in a single project, use a `.rgignore` (rg only) or `.ignore` (rg and fd) file in that project.

## Adding an entry

Add a `--glob=!name/` line to `config`, then mirror it in the sibling lists:

- [fd/ignore](../fd/ignore) for the file finder
- `filters.custom` in [nvim-tree.lua](../nvim/lua/danielyuan/lazy/nvim-tree.lua) for the file tree

## Upstream docs

- `man rg`, CONFIGURATION FILES section
- [ripgrep guide: configuration file](https://github.com/BurntSushi/ripgrep/blob/master/GUIDE.md#configuration-file)
