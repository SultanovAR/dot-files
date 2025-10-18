-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

vim.keymap.set("t", "<C-[>", "<Esc><Esc>")
vim.keymap.set({ "t", "n", "i", "v" }, "<D-s>", "<C-s>")
vim.keymap.set("n", "<S-h>", "<Cmd>bprevious<CR>", { silent = true, desc = "Prev buffer" })
vim.keymap.set("n", "<S-l>", "<Cmd>bnext<CR>", { silent = true, desc = "Next buffer" })
vim.keymap.set({ "i", "c", "t" }, "<C-j>", "<C-n>", { remap = true, silent = true })
vim.keymap.set({ "i", "c", "t" }, "<C-k>", "<C-p>", { remap = true, silent = true })
