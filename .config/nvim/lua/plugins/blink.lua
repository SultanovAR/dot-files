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

    -- Source priority: LSP wins over buffer/word matches. Buffer suggestions
    -- were outranking slower LSP responses, so dotted contexts (e.g. `std.`)
    -- showed nearby buffer words instead of module symbols.
    opts.sources = vim.tbl_deep_extend("force", opts.sources or {}, {
      default = { "lsp", "path", "snippets", "buffer" },
      providers = {
        lsp = {
          score_offset = 100,
        },
        buffer = {
          score_offset = -10,
          min_keyword_length = 4,
        },
      },
    })

    return opts
  end,
}
