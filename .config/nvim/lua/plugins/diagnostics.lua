return {
  {
    "neovim/nvim-lspconfig",

    -- 1) Настройки диагностики (отключаем лишний шум)
    opts = {
      diagnostics = {
        virtual_text = false, -- Отключаем текст в строках (как ты и хотел)
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

    -- 2) Логика отображения
    init = function()
      vim.o.updatetime = 250
      local diag_float_grp = vim.api.nvim_create_augroup("DiagnosticFloat", { clear = true })

      -- We use this variable to track ONLY the auto-opened window
      local last_auto_win = nil

      -- Helper function to close the window safely
      local function close_last_auto_win()
        if last_auto_win and vim.api.nvim_win_is_valid(last_auto_win) then
          pcall(vim.api.nvim_win_close, last_auto_win, true)
        end
        last_auto_win = nil
      end

      -- 1. AUTO-OPEN (CursorHold)
      vim.api.nvim_create_autocmd({ "CursorHold" }, {
        group = diag_float_grp,
        callback = function()
          if vim.fn.mode() ~= "n" then
            return
          end

          -- Guard: Don't trigger if we are already in a floating window (pickers, etc)
          if vim.api.nvim_win_get_config(0).relative ~= "" then
            return
          end

          local lnum = vim.api.nvim_win_get_cursor(0)[1] - 1
          local diagnostics = vim.diagnostic.get(0, { lnum = lnum })

          if #diagnostics == 0 then
            close_last_auto_win()
            return
          end

          -- Close any existing one before opening a new one
          close_last_auto_win()

          local _, winid = vim.diagnostic.open_float(nil, {
            scope = "line",
            focusable = false,
            close_events = { "CursorMoved", "InsertEnter", "BufLeave" },
            border = "rounded",
            source = false,
          })

          last_auto_win = winid
        end,
      })

      -- 2. THE CLEANER (Fixes Dired and 'gl' error)
      -- This trigger list ensures the window dies when moving to Dired or another file.
      vim.api.nvim_create_autocmd({ "CursorMoved", "BufLeave", "BufEnter", "InsertEnter" }, {
        group = diag_float_grp,
        callback = function()
          -- Only close if we are currently in a normal buffer.
          -- If the cursor is in a float (like the GL window), we leave it alone.
          if vim.api.nvim_win_get_config(0).relative == "" then
            close_last_auto_win()
          end
        end,
      })

      -- 3. KEYMAP (gl)
      vim.keymap.set("n", "gl", function()
        -- 1. Manually kill the auto-popup first so it doesn't conflict
        close_last_auto_win()

        -- 2. Open the focusable diagnostic window
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
