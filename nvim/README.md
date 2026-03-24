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
| node/npm | LSP servers, typescript-tools | Via NVM: `nvm install --lts` | Via NVM: `nvm install --lts` |
| C compiler | Treesitter parser compilation | `xcode-select --install` | `sudo apt install build-essential` |
| JetBrainsMono Nerd Font | Icons and UI | See [kitty/README.md](../kitty/README.md) | See [kitty/README.md](../kitty/README.md) |

## Core Settings

- **Leader:** Space
- **Tabs:** 2 spaces, smart indent
- **Line numbers:** Absolute + relative
- **Search:** Case-insensitive with smart case
- **Undo:** Persistent undo to `~/.local/state/nvim/undodir`
- **Scrolloff:** 10 lines

## Plugins

| Plugin | Purpose |
|--------|---------|
| catppuccin | Color scheme (Mocha variant) |
| telescope.nvim | Fuzzy finder (files, grep, buffers) |
| nvim-tree | File tree browser |
| blink.cmp | Autocompletion with LSP and snippet support |
| treesitter | Syntax highlighting |
| conform.nvim | Code formatting (format on save) |
| gitsigns | Git diff indicators in gutter |
| fugitive | Git integration |
| which-key | Keybind hints |
| undotree | Undo history visualization |
| todo-comments | Highlight TODO/FIXME/etc |
| typescript-tools | TypeScript language support |
| lazydev | Lua LSP for neovim config editing |
| Mason | LSP server and tool installer |

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

## Language Support

LSP servers and formatters are auto-installed via Mason on first launch.

| Language | LSP | Formatter |
|----------|-----|-----------|
| Lua | lua_ls | stylua |
| TypeScript/JavaScript | typescript-tools | - |
| Python | pyright | - |
| Vue | volar | - |
| Rust | rust_analyzer | - |
| Go | gopls | - |
| JSON | jsonls | - |
| YAML | yamlls | - |

Additional LSP servers can be added in `lua/danielyuan/lazy/lsp.lua`.
