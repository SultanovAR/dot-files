return {
  {
    "neovim/nvim-lspconfig",

    -- 1) only tweak diagnostic options (LazyVim will still set up servers)
    opts = {
      diagnostics = {
        virtual_text = false, -- no inline clutter
        signs = true,
        underline = true,
        update_in_insert = false,
        severity_sort = true,
        float = { border = "solid", source = false, header = "", prefix = "" },
      },
    },

    -- 2) add your CursorHold "message bar" in init (doesn't override plugin setup)
    init = function()
      vim.o.updatetime = math.min(vim.o.updatetime, 250) -- make CursorHold fire sooner

      local grp = vim.api.nvim_create_augroup("DoomDiagFloat", { clear = true })

      -- ensure diagnostics are enabled whenever an LSP attaches (just in case)
      vim.api.nvim_create_autocmd("LspAttach", {
        group = grp,
        callback = function(args)
          vim.diagnostic.enable(args.buf)
        end,
      })

      -- show a compact float for the current line, pinned to the top (Doom-like)
      vim.api.nvim_create_autocmd({ "CursorHold" }, {
        group = grp,
        callback = function()
          local lnum = vim.api.nvim_win_get_cursor(0)[1] - 1
          if #vim.diagnostic.get(0, { lnum = lnum }) == 0 then
            return
          end

          local ret = vim.diagnostic.open_float(nil, {
            scope = "line",
            focusable = false,
            border = "solid",
            source = false,
            header = "",
            prefix = "",
            close_events = { "CursorMoved", "InsertEnter", "BufLeave" },
            severity_sort = true,
          })

          local winid = type(ret) == "number" and ret or (ret and (ret.win_id or ret.winid or ret[1]))
          if winid and vim.api.nvim_win_is_valid(winid) then
            local cfg = vim.api.nvim_win_get_config(winid)
            cfg.relative, cfg.anchor, cfg.row, cfg.col, cfg.zindex = "win", "NW", 0, 0, 200
            vim.api.nvim_win_set_config(winid, cfg)
          end
        end,
      })

      -- quick peek key, like “describe here”
      vim.keymap.set("n", "gl", function()
        -- close all floating windows
        for _, win in ipairs(vim.api.nvim_list_wins()) do
          local cfg = vim.api.nvim_win_get_config(win)
          if cfg.relative ~= "" then
            pcall(vim.api.nvim_win_close, win, true)
          end
        end

        local bufnr = vim.api.nvim_get_current_buf()

        -- ensure diagnostics are enabled for this buffer
        vim.diagnostic.enable(bufnr)

        -- show diagnostics at cursor (or tell you there are none)
        local cur = vim.api.nvim_win_get_cursor(0)
        local lnum = cur[1] - 1
        local diags = vim.diagnostic.get(bufnr, { lnum = lnum })

        if #diags == 0 then
          -- try cursor-scope (sometimes line-scope is empty)
          diags = vim.diagnostic.get(bufnr, { lnum = lnum, col = cur[2] })
        end

        if #diags == 0 then
          vim.notify("No diagnostics under cursor", vim.log.levels.INFO)
          return
        end

        vim.diagnostic.open_float(nil, {
          scope = "cursor",
          focusable = false,
          border = "solid",
          source = false,
          header = "",
          prefix = "",
          severity_sort = true,
        })
      end, { desc = "Diagnostics: reset floats + show at cursor" })
    end,
  },
}
