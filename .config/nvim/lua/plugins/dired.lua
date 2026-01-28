return {
  {
    "X3eRo0/dired.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons", "MunifTanjim/nui.nvim" },
    cmd = { "Dired" },
    keys = {
      { "<leader>e", "<cmd>Dired<cr>", desc = "Dired" },
      { "<leader>fe", "<cmd>Dired<cr>", desc = "Dired" },
    },
    opts = {
      keybinds = {
        dired_enter = "l",
        dired_up = "h",
        dired_back = "-",
        dired_quit = "q",
      },
    },
    config = function(_, opts)
      require("dired").setup(opts)
    end,
  },
}
