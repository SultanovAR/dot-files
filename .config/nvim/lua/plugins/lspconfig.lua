-- K off a word (space, comma, paren) inside a call hovers the callee instead,
-- e.g. `jnp.where(done, reward, |)` shows the docs for jnp.where.
local function hover()
  local win = vim.api.nvim_get_current_win()
  local pos = vim.api.nvim_win_get_cursor(win)
  local char = vim.api.nvim_get_current_line():sub(pos[2] + 1, pos[2] + 1)
  if char:match("[%w_]") then
    return vim.lsp.buf.hover()
  end

  local ok, node = pcall(vim.treesitter.get_node)
  while ok and node and not node:type():find("call") do
    node = node:parent()
  end
  local callee = ok and node and (node:field("function")[1] or node:field("name")[1])
  if not callee then
    return vim.lsp.buf.hover()
  end

  -- hover() reads the cursor synchronously, so borrow it for the request
  local row, col = callee:end_()
  vim.api.nvim_win_set_cursor(win, { row + 1, math.max(col - 1, 0) })
  vim.lsp.buf.hover()
  vim.api.nvim_win_set_cursor(win, pos)
end

return {
  "neovim/nvim-lspconfig",
  opts = {
    servers = {
      mojo = {},
      ["*"] = {
        keys = {
          { "<c-k>", false, mode = "i" },
          { "K", hover, desc = "Hover" },
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
