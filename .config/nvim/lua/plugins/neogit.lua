return {
  "NeogitOrg/neogit",
  lazy = true,
  dependencies = {
    "nvim-lua/plenary.nvim",
    "folke/snacks.nvim",
  },
  cmd = "Neogit",
  keys = {
    { "<leader>gg", "<cmd>Neogit<cr>", desc = "Show Neogit UI" },
  },
  opts = {
    integrations = {
      diffview = false, -- отключает авто-merge трёх окон
    },
    kind = "tab", -- делает просмотр удобнее
  },
}
