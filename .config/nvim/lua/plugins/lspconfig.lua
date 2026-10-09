return {
  "neovim/nvim-lspconfig",
  opts = {
    servers = {
      mojo = {},
      ["*"] = {
        keys = {
          { "<c-k>", false, mode = "i" },
          { "<leader>cl", false }, -- LazyVim's "Lsp Info"; reused for diagnostics float
        },
      },
    },
    diagnostics = {
      virtual_text = false,
      underline = true,
      update_in_insert = false,
      severity_sort = true,
      signs = {
        text = {
          [vim.diagnostic.severity.ERROR] = "E",
          [vim.diagnostic.severity.WARN] = "W",
          [vim.diagnostic.severity.INFO] = "I",
          [vim.diagnostic.severity.HINT] = "H",
        },
      },
      float = {
        focusable = false,
        style = "minimal",
        border = "rounded",
        source = false,
        header = "",
        prefix = "",
        close_events = { "InsertEnter", "FocusLost" },
      },
    },
  },
}
