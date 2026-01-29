-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

vim.keymap.set("t", "<C-[>", "<Esc><Esc>")
vim.keymap.set({ "t", "n", "i", "v" }, "<D-s>", "<C-s>")
vim.keymap.set("n", "<S-h>", "<Cmd>bprevious<CR>", { silent = true, desc = "Prev buffer" })
vim.keymap.set("n", "<S-l>", "<Cmd>bnext<CR>", { silent = true, desc = "Next buffer" })
vim.keymap.set({ "i", "c", "t" }, "<C-j>", "<C-n>", { remap = true, silent = true })
vim.keymap.set({ "i", "c", "t" }, "<C-k>", "<C-p>", { remap = true, silent = true })
vim.keymap.set({ "n", "i" }, "<D-s>", "<C-s>", { remap = true })
vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", { remap = true, silent = true, desc = "Exit Terminal Mode" })
vim.keymap.set(
  { "t", "n" },
  "<leader>z",
  "<Cmd>ZenMode<CR>",
  { remap = true, silent = true, desc = "Enter/Exit Zen mode" }
)

vim.keymap.set("n", "<leader>gl", function()
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    local config = vim.api.nvim_win_get_config(win)
    if config.relative ~= "" then
      vim.api.nvim_win_close(win, false)
    end
  end
  vim.notify("Floating windows closed", vim.log.levels.INFO)
end, { desc = "Close all floating windows" })
