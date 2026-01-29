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
      -- Уменьшаем задержку для CursorHold, чтобы диагностика появлялась быстрее
      vim.o.updatetime = 250

      local diag_float_grp = vim.api.nvim_create_augroup("DiagnosticFloat", { clear = true })

      -- Автоматически открывать диагностику при наведении (CursorHold)
      vim.api.nvim_create_autocmd({ "CursorHold" }, {
        group = diag_float_grp,
        callback = function()
          -- Если мы в режиме вставки — не мешать
          if vim.fn.mode() ~= "n" then
            return
          end

          -- Проверяем, есть ли ошибки на текущей строке
          local lnum = vim.api.nvim_win_get_cursor(0)[1] - 1
          local diagnostics = vim.diagnostic.get(0, { lnum = lnum })

          if #diagnostics == 0 then
            return
          end

          -- Открываем плавающее окно.
          -- ВАЖНО: close_events делает всю грязную работу по закрытию окна за нас.
          vim.diagnostic.open_float(nil, {
            scope = "line", -- Или "cursor", если хочешь только под курсором
            focusable = false,
            close_events = {
              "BufLeave",
              "CursorMoved",
              "InsertEnter",
              "FocusLost",
            },
          })
        end,
      })

      -- Клавиша gl: Показать полную диагностику под курсором (если авто-окно не вместило всё)
      vim.keymap.set("n", "gl", function()
        local bufnr = vim.api.nvim_get_current_buf()
        local lnum = vim.api.nvim_win_get_cursor(0)[1] - 1

        -- Сначала пробуем показать для всей строки
        local diags = vim.diagnostic.get(bufnr, { lnum = lnum })

        if #diags == 0 then
          vim.notify("No diagnostics here", vim.log.levels.INFO)
          return
        end

        vim.diagnostic.open_float(nil, {
          scope = "line",
          focusable = true, -- Тут можно фокус, чтобы скопировать ошибку
          border = "solid",
          source = false,
        })
      end, { desc = "Show diagnostics at cursor" })
    end,
  },
}
