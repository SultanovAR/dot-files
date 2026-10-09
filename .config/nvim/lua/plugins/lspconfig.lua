return {
  "neovim/nvim-lspconfig",
  opts = {
    servers = {
      mojo = {},
      ["*"] = {
        keys = {
          { "<c-k>", false, mode = "i" },
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
        -- focusable: a second <leader>cd jumps into the float (like K K)
        focusable = true,
        style = "minimal",
        border = "rounded",
        source = false,
        header = "",
        prefix = "",
      },
    },
  },
}
