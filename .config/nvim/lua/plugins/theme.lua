return {
  {
    "NTBBloodbath/doom-one.nvim",
    priority = 1000, -- load before UI plugins
    config = function()
      -- Core options
      vim.g.doom_one_cursor_coloring = false
      vim.g.doom_one_terminal_colors = true
      vim.g.doom_one_enable_treesitter = true
      vim.g.doom_one_transparent_background = false
      vim.g.doom_one_diagnostics_text_color = false
      vim.g.doom_one_pumblend_enable = false
      vim.g.doom_one_pumblend_transparency = 20

      -- Plugin integrations (use the correct keys)
      vim.g.doom_one_plugin_telescope = true
      vim.g.doom_one_plugin_nvim_tree = true
      -- (there is no lualine integration option)

      -- Do NOT call colorscheme here; let LazyVim set it below
    end,
  },
  {
    "LazyVim/LazyVim",
    opts = { colorscheme = "doom-one" },
  },
}
