-- Disable Netrw for Nvim-tree
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- NOTE: Must happen before plugins are loaded (Otherwise wrong leader will be used)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Turn on line numbers and relative line numbers
vim.opt.nu = true
vim.opt.relativenumber = true
vim.opt.cursorline = false

-- Setup default tabs
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.smartindent = true
vim.opt.breakindent = true

vim.opt.wrap = true

vim.opt.backup = false
vim.opt.swapfile = false
local undodir = (os.getenv("XDG_STATE_HOME") or os.getenv("HOME") .. "/.local/state") .. "/nvim/undodir"
vim.fn.mkdir(undodir, "p")
vim.opt.undodir = undodir
vim.opt.undofile = true

-- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.incsearch = true

vim.opt.termguicolors = true
vim.g.have_nerd_font = true
vim.opt.showmode = false

-- Minimum number of lines to keep above and below the cursor
vim.opt.scrolloff = 10
vim.opt.signcolumn = "yes"

-- Raise dialog to confirm if we are performing an operation that would fail due to unsaved changes
vim.opt.confirm = true

-- Sets how neovim will display certain whitespace characters in the editor.
--  See `:help 'list'`
--  and `:help 'listchars'`
vim.opt.list = true
vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }

vim.opt.inccommand = "split"

-- Decrease update time
vim.opt.updatetime = 250

-- Time to wait for next key in a sequence (default 1000ms)
vim.opt.timeoutlen = 300

-- Configure how new splits should be opened
vim.opt.splitright = true
vim.opt.splitbelow = true
