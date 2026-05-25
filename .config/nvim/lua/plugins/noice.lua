return {
  {
    "folke/noice.nvim",
    opts = {
      lsp = {
        progress = { enabled = false },
        signature = { enabled = true },
        hover = { silent = true },
        override = {
          ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
          ["vim.lsp.util.stylize_markdown"] = true,
          ["cmp.entry.get_documentation"] = true,
        },
      },
      presets = { lsp_doc_border = true },
      views = {
        hover = {
          border = { style = "rounded" },
          size = { max_width = 80, max_height = 25 },
          win_options = { wrap = true, linebreak = true },
        },
      },
      routes = {
        { filter = { event = "msg_show", find = "written" }, opts = { skip = true } },
      },
    },
  },
}
