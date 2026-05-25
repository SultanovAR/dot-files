-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

-- Diagnostic hover popup on CursorHold.
-- Uses position-diff cleaner to dodge spurious CursorMoved (neovim/neovim#12923).
local diag_float_grp = vim.api.nvim_create_augroup("DiagnosticFloat", { clear = true })

local last_auto_win = nil
local last_auto_pos = nil

local function close_last_auto_win()
  if last_auto_win and vim.api.nvim_win_is_valid(last_auto_win) then
    pcall(vim.api.nvim_win_close, last_auto_win, true)
  end
  last_auto_win = nil
  last_auto_pos = nil
end

vim.api.nvim_create_autocmd("CursorHold", {
  group = diag_float_grp,
  callback = function()
    if vim.fn.mode() ~= "n" then
      return
    end
    if vim.api.nvim_win_get_config(0).relative ~= "" then
      return
    end

    local lnum = vim.api.nvim_win_get_cursor(0)[1] - 1
    if #vim.diagnostic.get(0, { lnum = lnum }) == 0 then
      close_last_auto_win()
      return
    end

    close_last_auto_win()

    local _, winid = vim.diagnostic.open_float(nil, {
      scope = "line",
      focusable = false,
      close_events = {}, -- managed below; default would include CursorMoved
      border = "rounded",
      source = false,
    })

    last_auto_win = winid
    last_auto_pos = vim.api.nvim_win_get_cursor(0)
  end,
})

vim.api.nvim_create_autocmd({ "CursorMoved", "InsertEnter", "BufLeave" }, {
  group = diag_float_grp,
  callback = function()
    if vim.api.nvim_win_get_config(0).relative ~= "" then
      return
    end
    if last_auto_pos then
      local pos = vim.api.nvim_win_get_cursor(0)
      if pos[1] == last_auto_pos[1] and pos[2] == last_auto_pos[2] then
        return -- spurious CursorMoved; cursor did not actually move
      end
    end
    close_last_auto_win()
  end,
})
