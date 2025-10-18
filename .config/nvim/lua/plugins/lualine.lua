return {
  "nvim-lualine/lualine.nvim",
  event = "VeryLazy",
  opts = function(_, opts)
    opts.options = vim.tbl_deep_extend("force", opts.options or {}, {
      theme = "auto",
      globalstatus = true,
      icons_enabled = false,
      section_separators = { left = "", right = "" },
      component_separators = { left = "", right = "" },
      always_divide_middle = false,
    })

    local function diag(section, label)
      return {
        "diagnostics",
        sources = { "nvim_diagnostic" }, -- current buffer
        sections = { section }, -- "error" | "warn" | "hint" | "info"
        symbols = { [section] = label .. ":" },
        colored = true, -- color by severity
        always_visible = true, -- show 0 (like your screenshot)
        padding = { left = 0, right = 1 },
      }
    end

    opts.sections = {
      lualine_a = {
        {
          "mode",
          fmt = function(s)
            return s:sub(1, 1)
          end,
        },
      },
      lualine_b = {},
      lualine_c = { { "filename", path = 1, file_status = false } },
      lualine_x = {},
      -- Right side: labeled, compact, color-coded counters
      lualine_y = {
        diag("error", "E"),
        diag("warn", "W"),
        diag("hint", "H"),
        diag("info", "I"),
      },
      lualine_z = { "location" },
    }

    opts.inactive_sections = {
      lualine_a = {},
      lualine_b = {},
      lualine_c = { { "filename", path = 1 } },
      lualine_x = {},
      lualine_y = {},
      lualine_z = {},
    }

    return opts
  end,
}
