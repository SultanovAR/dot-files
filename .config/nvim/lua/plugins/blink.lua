return {
  "saghen/blink.cmp",
  opts = function(_, opts)
    -- Настройка документации (чтобы не залипала)
    opts.completion = opts.completion or {}
    opts.completion.documentation = {
      auto_show = true,
      auto_show_delay_ms = 200, -- Добавляем задержку 200мс (по умолчанию 0 или очень мало)
      window = {
        border = "rounded",
      },
    }

    -- Твои существующие настройки клавиш
    opts.keymap = vim.tbl_deep_extend("force", opts.keymap or {}, {
      ["<C-j>"] = { "select_next", "fallback" },
      ["<C-k>"] = { "select_prev", "fallback" },
      ["<Tab>"] = { "select_and_accept", "fallback" },
    })

    -- CMDLINE MODE
    opts.cmdline = opts.cmdline or {}
    opts.cmdline.keymap = vim.tbl_deep_extend("force", opts.cmdline.keymap or { preset = "cmdline" }, {
      ["<Tab>"] = { "select_and_accept", "fallback" },
    })

    -- Drop standalone snippet source: it returned instantly while LSP was
    -- warming and locked the selection before LSP items arrived (user saw
    -- dateDMY/dateMDY when typing `from std.at`). LSP delivers its own
    -- snippet items via completionItem.snippetSupport, so nothing real lost.
    -- Keep buffer at neutral offset so recent words still appear when LSP
    -- has no matches.
    opts.sources = vim.tbl_deep_extend("force", opts.sources or {}, {
      default = { "lsp", "path", "buffer" },
      providers = {
        -- async=true: don't block menu while LSP responds. Items stream in
        -- and re-sort (score_offset=100 puts LSP top once it arrives).
        -- Without this, slow/isIncomplete LSP responses cause buffer-only
        -- menu on every keystroke (see blink issue #543).
        lsp = { score_offset = 100, async = true },
        path = { score_offset = 5 },
        buffer = { score_offset = 0 },
      },
    })

    return opts
  end,
}
