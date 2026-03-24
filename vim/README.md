# Vim (Legacy)

Vim configuration kept as a lightweight fallback for machines where neovim isn't available.

## Settings

- **Tabs:** 2 spaces
- **Color scheme:** Stereokai
- **No swap files**
- CUDA syntax support (`.cu`, `.cuh`)
- Arrow keys disabled (enforces hjkl)

## Plugins (via Vundle)

| Plugin | Purpose |
|--------|---------|
| vim-airline | Status bar |
| vim-airline-themes | Airline themes |
| supertab | Tab completion |
| vim-fugitive | Git integration |
| vim-bufferline | Buffer navigation |
| nerdtree | File tree |
| ctrlp.vim | Fuzzy file finder |
| vim-surround | Surround manipulation |
| vim-commentary | Comment toggle |

## Key Bindings

| Binding | Action |
|---------|--------|
| `Ctrl-N` | Toggle NERDTree |
| `Ctrl-P` | CtrlP fuzzy finder |
