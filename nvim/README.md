# Neovim

Lua-based neovim config using lazy.nvim for plugin management. Plugins auto-install on first launch.

## Dependencies

These must be installed before first launch:

| Tool | Purpose | macOS | Linux |
|------|---------|-------|-------|
| neovim 0.11+ | Editor | `brew install neovim` | See [neovim install guide](https://github.com/neovim/neovim/blob/master/INSTALL.md) |
| tree-sitter-cli | Parser compilation | `brew install tree-sitter-cli` | `npm install -g tree-sitter-cli` or `cargo install tree-sitter-cli` |
| ripgrep | Telescope live grep | `brew install ripgrep` | `sudo apt install ripgrep` |
| fd | Telescope file finder | `brew install fd` | `sudo apt install fd-find` |
| node/npm | LSP servers, typescript-tools | Via mise: `mise use -g node@lts` | Via mise: `mise use -g node@lts` |
| C compiler | Treesitter parser compilation | `xcode-select --install` | `sudo apt install build-essential` |
| JetBrainsMono Nerd Font | Icons and UI | See [kitty/README.md](../kitty/README.md) | See [kitty/README.md](../kitty/README.md) |
| ImageMagick | Inline images in markdown (non-PNG formats) | `brew install imagemagick` | `sudo apt install imagemagick` |

## Core Settings

- **Leader:** Space
- **Tabs:** 2 spaces, smart indent
- **Line numbers:** Absolute + relative
- **Search:** Case-insensitive with smart case
- **Undo:** Persistent undo to `~/.local/state/nvim/undodir`
- **Scrolloff:** 10 lines
- **Splits:** Open right and below

## Plugins

| Plugin | Purpose |
|--------|---------|
| catppuccin | Color scheme (Mocha variant) |
| telescope.nvim | Fuzzy finder (files, grep, buffers) with fzf-native sorter |
| nvim-tree | File tree browser |
| blink.cmp | Autocompletion with LSP and snippet support |
| treesitter | Syntax highlighting |
| conform.nvim | Code formatting (manual via `<leader>f`, opt-in format-on-save per project) |
| gitsigns | Git diff indicators in gutter |
| fugitive | Git integration |
| diffview.nvim | File-by-file diff viewer and file history |
| which-key | Keybind hints |
| trouble.nvim | Diagnostics panel (project-wide and per-buffer) |
| snacks.nvim | Dashboard, indent guides, notifications, scratch buffers, inline images |
| render-markdown.nvim | In-buffer markdown rendering (headings, tables, checkboxes, callouts) |
| undotree | Undo history visualization |
| todo-comments | Highlight TODO/FIXME/etc |
| typescript-tools | TypeScript language support |
| lazydev | Lua LSP for neovim config editing |
| Mason | LSP server and tool installer |
| nvim-surround | Add/change/delete surrounding chars |
| nvim-autopairs | Auto-close brackets, quotes, etc |
| nvim-ts-autotag | Auto-close and rename HTML/JSX/Vue tags |
| flash.nvim | Quick cursor jumps with labels |
| harpoon | Pin and jump between files instantly |

## Key Bindings

Bindings are organized by three mental models:
- **`g` = git (repo-level)**, status, blame, log, diffs
- **`h` = hunks (change-level)**, staging, resetting, previewing individual changes
- **`s` = search**, finding things via telescope

Within groups, letters stay consistent where possible: `s` = the main action, `b/B` = blame, `d` = diff/diagnostics, `r` = reset/resume. Capital = bigger version (`h` file history → `H` repo history, `b` blame line → `B` toggle blame).

### Git (`<leader>g`)

| Binding | Action | Plugin |
|---------|--------|--------|
| `<leader>gs` | Git status | fugitive |
| `<leader>gb` | Blame (full file) | fugitive |
| `<leader>gl` | Log (oneline) | fugitive |
| `<leader>gd` | Diff view (working tree vs index) | diffview |
| `<leader>gm` | Diff against branch (prompted, default: main) | diffview |
| `<leader>gq` | Close diff view | diffview |
| `<leader>gh` | File history (current file) | diffview |
| `<leader>gH` | File history (full repo) | diffview |

Diffview fold controls: `zo` expand, `zc` collapse, `zR` expand all, `zM` collapse all.

### Hunks (`<leader>h`)

| Binding | Action |
|---------|--------|
| `]c` / `[c` | Next / previous hunk |
| `<leader>hs` | Stage hunk (normal + visual) |
| `<leader>hr` | Reset hunk (normal + visual) |
| `<leader>hS` | Stage buffer |
| `<leader>hu` | Undo stage hunk |
| `<leader>hR` | Reset buffer |
| `<leader>hp` | Preview hunk |
| `<leader>hb` | Blame line (one-shot) |
| `<leader>hB` | Toggle inline blame |
| `<leader>hd` | Diff against index |

### Search (`<leader>s`)

| Binding | Action |
|---------|--------|
| `<leader>sf` | Find files |
| `<leader>sF` | Find files (including gitignored and hidden) |
| `<leader>sg` | Live grep |
| `<leader>sG` | Live grep (including gitignored and hidden) |
| `<leader>sw` | Grep current word |
| `<leader>sh` | Help tags |
| `<leader>sk` | Keymaps |
| `<leader>ss` | Telescope builtins |
| `<leader>sd` | Diagnostics |
| `<leader>sr` | Search and replace (project-wide, grug-far) |
| `<leader>sl` | Resume last search |
| `<leader>s.` | Recent files |
| `<leader>sc` | Git commits |
| `<leader>sb` | Git branches |
| `<leader>st` | TODOs |
| `<leader><leader>` | Open buffers |

`<leader>sF` and `<leader>sG` bypass `.gitignore` (for specs, drafts, and other untracked files) but still respect the always-ignore lists in [fd/ignore](../fd/ignore) and [ripgrep/config](../ripgrep/config), so `.git` and `node_modules` stay out of results.

### Diagnostics (`<leader>x`)

| Binding | Action |
|---------|--------|
| `<leader>xx` | Project-wide diagnostics |
| `<leader>xd` | Current buffer diagnostics |
| `<leader>xq` | Quickfix list |
| `<leader>q` | Diagnostics float |
| `<leader>Q` | Location list |

### Windows (`<leader>w`)

| Binding | Action |
|---------|--------|
| `<leader>wv` | Vertical split (side-by-side) |
| `<leader>ws` | Horizontal split |
| `<leader>wd` | Close window |
| `<leader>wo` | Close all other windows |
| `<leader>w=` | Balance window sizes |
| `<C-h/j/k/l>` | Move focus left/down/up/right |
| `<leader>wH/J/K/L` | Move window position left/down/up/right |
| `<leader>ww` | Cycle to next window |

### LSP (active when LSP attaches)

| Binding | Action |
|---------|--------|
| `grn` | Rename symbol |
| `gra` | Code actions |
| `grr` | References |
| `gri` | Implementations |
| `grd` | Go to definition |
| `grD` | Go to declaration |
| `gO` | Document symbols |
| `gW` | Workspace symbols |
| `grt` | Type definition |
| `<leader>ih` | Toggle inlay hints |

### General

| Binding | Action |
|---------|--------|
| `<leader>y` / `Y` | Yank to system clipboard |
| `<leader>d` | Delete to void register |
| `<leader>f` | Format buffer |
| `<leader>u` | Toggle undo tree |
| `<leader>m` | Toggle markdown rendering (markdown buffers only) |
| `<leader>t` | Toggle file tree |
| `<leader>.` | Toggle scratch buffer (use this to close, not `:q`) |
| `<leader>>` | Select from saved scratch buffers |
| `<leader>n` | Notification history |
| `<leader>a` | Add file to harpoon |
| `<leader>e` | Open harpoon menu |
| `<leader>1-4` | Jump to harpoon file 1-4 |

The file tree shows gitignored files (dimmed, with the `◌` git icon), except the always-hidden names in `filters.custom` (`.git`, `node_modules`). Inside the tree, `I` toggles gitignored files, `H` toggles dotfiles, and `U` toggles the always-hidden list.

### Motion (Flash)

| Binding | Action |
|---------|--------|
| `s{chars}` | Jump to any match (labels appear after typing) |
| `S` | Treesitter select (label a code block/function/node to select it) |
| `<C-s>` | Toggle flash labels during `/` search |

Flash also auto-labels matches during `/` search, so you can jump to any result directly instead of pressing `n`.

### Surround

| Action | Binding | Example |
|--------|---------|---------|
| Add surrounding | `ys{motion}{char}` | `ysiw)` wraps word in parens |
| Change surrounding | `cs{old}{new}` | `cs"'` changes `"hello"` to `'hello'` |
| Delete surrounding | `ds{char}` | `ds(` removes surrounding parens |

Works with `()`, `[]`, `{}`, `""`, `''`, `` ` ` ``, HTML tags (`t`), and more.

## Markdown

Markdown files render in-buffer, close to how GitHub/Forgejo display them:

- **render-markdown.nvim** draws headings, tables, checkboxes, code blocks, and callouts (`> [!NOTE]` etc) in normal mode, and reverts to raw text on the line being edited in insert mode. Toggle with `<leader>m`.
- **snacks.image** draws `![alt](path)` images inline, both local files and URLs. Requires a terminal with the kitty graphics protocol (ghostty and kitty both work) and ImageMagick for non-PNG formats.

## Hard Reset

To wipe all plugins, state, and cache and start fresh (config is preserved):

```bash
rm -rf ~/.local/share/nvim ~/.local/state/nvim ~/.cache/nvim
```

Next time you open nvim, lazy.nvim will re-bootstrap and reinstall everything.

## Language Support

LSP servers and formatters are auto-installed via Mason on first launch.

| Language | LSP | Formatter |
|----------|-----|-----------|
| Lua | lua_ls | stylua |
| TypeScript/JavaScript | typescript-tools | prettier |
| Python | pyright | ruff |
| Vue | vue_ls | prettier |
| Rust | rust_analyzer | rustfmt (via rustup) |
| Go | gopls | goimports |
| JSON | jsonls | prettier |
| YAML | yamlls | prettier |

Additional LSP servers can be added in `lua/danielyuan/lazy/lsp.lua`.

## Per-Project Format on Save

Format-on-save is disabled by default. To enable it for a specific project, create a `.nvim.lua` file in the project root:

```lua
vim.g.format_on_save = true
```

This uses neovim's built-in `exrc` feature to load `.nvim.lua` from the project directory. The file is globally gitignored via `~/.config/git/ignore`, so it won't show up in any repo's `git status`.
