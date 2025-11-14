return {
  "saghen/blink.cmp",
  opts = function(_, opts)
    -- INSERT MODE / LSP
    opts.keymap = vim.tbl_deep_extend("force", opts.keymap or {}, {
      ["<C-j>"] = { "select_next", "fallback" },
      ["<C-k>"] = { "select_prev", "fallback" },
      ["<Tab>"] = { "select_and_accept", "fallback" },
    })

    -- CMDLINE MODE (:, /, ? и т.п.)
    opts.cmdline = opts.cmdline or {}
    opts.cmdline.keymap = vim.tbl_deep_extend("force", opts.cmdline.keymap or { preset = "cmdline" }, {
      ["<Tab>"] = { "select_and_accept", "fallback" },
    })
  end,
}
