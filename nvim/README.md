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
| conform.nvim | Code formatting (format on save) |
| gitsigns | Git diff indicators in gutter |
| fugitive | Git integration |
| diffview.nvim | File-by-file diff viewer and file history |
| which-key | Keybind hints |
| trouble.nvim | Diagnostics panel (project-wide and per-buffer) |
| snacks.nvim | Dashboard, indent guides, notifications, scratch buffers |
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

### General

| Binding | Action |
|---------|--------|
| `<leader>y` | Yank to system clipboard |
| `<leader>Y` | Yank line to system clipboard |
| `<leader>d` | Delete to void register |
| `<leader>f` | Format buffer |
| `<leader>u` | Toggle undo tree |
| `<leader>t` | Toggle file tree |
| `<leader>.` | Open scratch buffer |
| `<leader>n` | Notification history |

### Harpoon

| Binding | Action |
|---------|--------|
| `<leader>a` | Add current file to harpoon |
| `<leader>e` | Open harpoon menu (reorder/remove) |
| `<leader>1-4` | Jump to harpoon file 1-4 |

### Flash

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

### Diagnostics (Trouble)

| Binding | Action |
|---------|--------|
| `<leader>xx` | Project-wide diagnostics |
| `<leader>xd` | Current buffer diagnostics |
| `<leader>xq` | Quickfix list |

### Windows

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

### Telescope (Search)

| Binding | Action |
|---------|--------|
| `<leader>sf` | Find files |
| `<leader>sg` | Live grep |
| `<leader>sw` | Grep current word |
| `<leader>sh` | Help tags |
| `<leader>sk` | Keymaps |
| `<leader>sd` | Diagnostics |
| `<leader>sr` | Resume last search |
| `<leader>s.` | Recent files |
| `<leader><leader>` | Open buffers |

### LSP

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

### Git Hunks

| Binding | Action |
|---------|--------|
| `]c` | Next hunk |
| `[c` | Previous hunk |
| `<leader>hs` | Stage hunk (normal + visual) |
| `<leader>hr` | Reset hunk (normal + visual) |
| `<leader>hS` | Stage buffer |
| `<leader>hu` | Undo stage hunk |
| `<leader>hR` | Reset buffer |
| `<leader>hp` | Preview hunk |
| `<leader>hb` | Blame line |
| `<leader>hd` | Diff against index |

### Diff View

| Binding | Action |
|---------|--------|
| `<leader>gd` | Open diff view (working tree vs index) |
| `<leader>gh` | File history for current file |
| `zo` | Expand folded unchanged region |
| `zR` | Expand all folds (show full file) |
| `zM` | Collapse all folds (show hunks only) |
| `zc` | Collapse fold under cursor |

Also supports `:DiffviewOpen main..HEAD` to diff against a branch. Close with `:DiffviewClose`.

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
