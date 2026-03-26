-- Yanks current selection to clipboard
vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]])

-- Yanks current line to clipboard
vim.keymap.set("n", "<leader>Y", [["+Y]])

-- Deletes to void register
vim.keymap.set({ "n", "v" }, "<leader>d", [["_d]])

-- Diagnostics
vim.keymap.set("n", "<leader>q", vim.diagnostic.open_float, { desc = "Show diagnostic in float" })
vim.keymap.set("n", "<leader>Q", vim.diagnostic.setloclist, { desc = "Diagnostics to location list" })

-- Fast window navigation
vim.keymap.set("n", "<C-h>", "<C-w>h", { desc = "Move to left window" })
vim.keymap.set("n", "<C-j>", "<C-w>j", { desc = "Move to below window" })
vim.keymap.set("n", "<C-k>", "<C-w>k", { desc = "Move to above window" })
vim.keymap.set("n", "<C-l>", "<C-w>l", { desc = "Move to right window" })

-- Window management
vim.keymap.set("n", "<leader>wv", "<cmd>vsplit<cr>", { desc = "Vertical split" })
vim.keymap.set("n", "<leader>ws", "<cmd>split<cr>", { desc = "Horizontal split" })
vim.keymap.set("n", "<leader>wd", "<cmd>close<cr>", { desc = "Close window" })
vim.keymap.set("n", "<leader>wo", "<cmd>only<cr>", { desc = "Close other windows" })
vim.keymap.set("n", "<leader>w=", "<C-w>=", { desc = "Balance windows" })
vim.keymap.set("n", "<leader>wh", "<C-w>h", { desc = "Move to left window" })
vim.keymap.set("n", "<leader>wj", "<C-w>j", { desc = "Move to below window" })
vim.keymap.set("n", "<leader>wk", "<C-w>k", { desc = "Move to above window" })
vim.keymap.set("n", "<leader>wl", "<C-w>l", { desc = "Move to right window" })
vim.keymap.set("n", "<leader>wH", "<C-w>H", { desc = "Move window to left" })
vim.keymap.set("n", "<leader>wJ", "<C-w>J", { desc = "Move window to bottom" })
vim.keymap.set("n", "<leader>wK", "<C-w>K", { desc = "Move window to top" })
vim.keymap.set("n", "<leader>wL", "<C-w>L", { desc = "Move window to right" })
vim.keymap.set("n", "<leader>ww", "<C-w>w", { desc = "Cycle to next window" })
