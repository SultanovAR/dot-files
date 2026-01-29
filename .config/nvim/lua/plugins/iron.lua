return {
  "Vigemus/iron.nvim",
  event = "VeryLazy",
  keys = {
    -- Send Visual Selection (Отправить выделенное + показать окно)
    {
      "<leader>cr",
      function()
        local iron = require("iron.core")
        iron.visual_send()
        -- Опционально: можно раскомментировать строку ниже, чтобы фокус прыгал в терминал
        -- iron.focus_on_save()
      end,
      mode = { "v" },
      desc = "Send Visual to REPL",
    },
    -- Send Current Line (Отправить строку + показать окно)
    {
      "<leader>cr",
      function()
        local iron = require("iron.core")
        iron.send_line()
      end,
      mode = { "n" },
      desc = "Send Line to REPL",
    },
    -- Toggle REPL (Показать/Скрыть окно без потери данных)
    {
      "<leader>rs",
      function()
        require("iron.core").repl_toggle_handler()
      end,
      mode = { "n" },
      desc = "Toggle REPL",
    },
    -- Restart REPL (Убить процесс и начать заново)
    {
      "<leader>rr",
      function()
        require("iron.core").repl_restart()
      end,
      mode = { "n" },
      desc = "Restart REPL",
    },
    -- Focus REPL (Переключить фокус туда-сюда)
    {
      "<leader>rf",
      function()
        require("iron.core").focus_on(vim.bo.filetype)
      end,
      mode = { "n" },
      desc = "Focus REPL",
    },
  },
  config = function()
    local iron = require("iron.core")
    local view = require("iron.view")

    iron.setup({
      config = {
        -- scratch_repl = false значит, что при закрытии окна процесс НЕ убивается.
        -- Окно просто скрывается. Чтобы вернуть его, нажми <leader>rs
        scratch_repl = false,

        -- Открывать справа вертикально, занимая 40%
        repl_open_cmd = view.split.vertical.botright(0.40),

        repl_definition = {
          python = {
            -- Используем ipython для красоты (если есть), иначе python3
            command = function(meta)
              local filename = vim.api.nvim_buf_get_name(meta.current_bufnr)
              -- Если используешь uv, оставляем твою команду
              return { "uv", "run", "--with", "ipython", "ipython", "--no-autoindent", "-i" }
            end,
            format = require("iron.fts.common").bracketed_paste_python,
          },
        },
      },
      highlight = {
        italic = true,
      },
      ignore_blank_lines = true,
    })
  end,
}
