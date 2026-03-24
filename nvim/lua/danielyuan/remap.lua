-- Yanks current selection to clipboard
vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]])

-- Yanks current line to clipboard
vim.keymap.set("n", "<leader>Y", [["+Y]])

-- Deletes to void register
vim.keymap.set({ "n", "v" }, "<leader>d", [["_d]])
