-- Mojo-specific tweaks. LSP server registration lives in plugins/lspconfig.lua
-- (`mojo = {}`); this file adds an ad-hoc :MojoLspI command that restarts the
-- mojo LSP for the current buffer with extra `-I <dir>` include paths.
return {
  "neovim/nvim-lspconfig",
  init = function()
    vim.api.nvim_create_autocmd("FileType", {
      pattern = "mojo",
      callback = function()
        vim.bo.tabstop = 4
        vim.bo.shiftwidth = 4
        vim.bo.softtabstop = 4
        vim.bo.expandtab = true
      end,
    })

    vim.api.nvim_create_user_command("MojoLspI", function(opts)
      local bufnr = vim.api.nvim_get_current_buf()
      local includes = {}
      for _, d in ipairs(opts.fargs) do
        table.insert(includes, vim.fn.fnamemodify(d, ":p"))
      end
      if #includes == 0 then
        vim.notify("MojoLspI: need at least one dir", vim.log.levels.ERROR)
        return
      end

      for _, c in ipairs(vim.lsp.get_clients({ bufnr = bufnr, name = "mojo" })) do
        vim.lsp.stop_client(c.id, true)
      end
      for _, c in ipairs(vim.lsp.get_clients({ bufnr = bufnr, name = "mojo-i" })) do
        vim.lsp.stop_client(c.id, true)
      end

      local cmd = { "mojo-lsp-server" }
      for _, d in ipairs(includes) do
        table.insert(cmd, "-I")
        table.insert(cmd, d)
      end

      vim.defer_fn(function()
        vim.lsp.start({
          name = "mojo-i",
          cmd = cmd,
          root_dir = vim.fn.getcwd(),
          filetypes = { "mojo" },
        }, { bufnr = bufnr })
        vim.notify("MojoLspI started: " .. table.concat(includes, ", "))
      end, 100)
    end, {
      nargs = "+",
      complete = "dir",
      desc = "Restart Mojo LSP with extra -I include dirs",
    })
  end,
}
