vim.g.mapleader = ","

-- The most important
vim.keymap.set("i", "jk", "<Esc>")
vim.keymap.set({ "n", "v" }, ";", ":")

vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)

-- Navigation
vim.keymap.set("n", "<C-H>", "<C-W><C-H>")
vim.keymap.set("n", "<C-J>", "<C-W><C-J>")
vim.keymap.set("n", "<C-K>", "<C-W><C-K>")
vim.keymap.set("n", "<C-L>", "<C-W><C-L>")