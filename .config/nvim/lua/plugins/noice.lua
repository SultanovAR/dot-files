return {
  {
    "folke/noice.nvim",
    opts = {
      lsp = { progress = { enabled = false }, signature = { enabled = true }, hover = { silent = true } },
      presets = { lsp_doc_border = true },
      routes = {
        { filter = { event = "msg_show", find = "written" }, opts = { skip = true } },
      },
    },
  },
}
