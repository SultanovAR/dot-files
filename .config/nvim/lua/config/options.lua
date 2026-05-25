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

-- Diagnostics configured via opts in lua/plugins/lspconfig.lua (LazyVim
-- calls vim.diagnostic.config after plugins load — settings here would be
-- overwritten). Hover popup managed by lua/config/autocmds.lua.
