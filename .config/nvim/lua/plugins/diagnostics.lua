return {
  {
    "neovim/nvim-lspconfig",

    opts = {
      diagnostics = {
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
        },
      },
    },

    init = function()
      vim.o.updatetime = 250

      -- Cap LSP log noise; default WARN can balloon the log file.
      pcall(vim.lsp.set_log_level, "ERROR")

      local diag_float_grp = vim.api.nvim_create_augroup("DiagnosticFloat", { clear = true })

      -- Track only the auto-opened window + the cursor position at open time.
      -- Position diff guards against spurious CursorMoved events emitted just
      -- after open_float (see neovim/neovim#12923).
      local last_auto_win = nil
      local last_auto_pos = nil

      local function close_last_auto_win()
        if last_auto_win and vim.api.nvim_win_is_valid(last_auto_win) then
          pcall(vim.api.nvim_win_close, last_auto_win, true)
        end
        last_auto_win = nil
        last_auto_pos = nil
      end

      -- 1. AUTO-OPEN on CursorHold
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
            close_events = {}, -- managed by the cleaner autocmd below
            border = "rounded",
            source = false,
          })

          last_auto_win = winid
          last_auto_pos = vim.api.nvim_win_get_cursor(0)
        end,
      })

      -- 2. CLEANER — close only when the cursor actually moved
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

      -- 3. KEYMAP (gl) — focusable, manual
      vim.keymap.set("n", "gl", function()
        close_last_auto_win()
        vim.diagnostic.open_float(nil, {
          scope = "line",
          focusable = true,
          border = "rounded",
          source = false,
        })
      end, { desc = "Show diagnostics" })
    end,
  },
}
