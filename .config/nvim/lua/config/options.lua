-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- vim
vim.opt.relativenumber = false
vim.opt.gdefault = true
vim.lsp.semantic_tokens.enable = true
vim.o.updatetime = 250

-- Cap LSP log noise (default WARN balloons ~/.local/state/nvim/lsp.log)
pcall(vim.lsp.set_log_level, "ERROR")

--python
vim.g.lazyvim_python_lsp = "basedpyright"
vim.g.lazyvim_python_ruff = "ruff"

-- Diagnostics: signs only, hover popup managed by autocmds.lua.
-- close_events intentionally omits CursorMoved (see neovim/neovim#12923 —
-- pending CursorMoved closes the float before it can paint).
vim.diagnostic.config({
  virtual_text = false,
  signs = true,
  underline = true,
  update_in_insert = false,
  severity_sort = true,
  float = {
    focusable = false,
    style = "minimal",
    border = "rounded",
    source = false,
    header = "",
    prefix = "",
    close_events = { "InsertEnter", "FocusLost" },
  },
})
