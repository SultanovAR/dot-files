return {
  "Vigemus/iron.nvim",
  event = "VeryLazy",
  keys = {
    {
      "<leader>cr",
      function()
        require("iron.core").visual_send()
      end,
      mode = { "v" },
      desc = "Send Visual Selection to REPL",
    },
  },
  config = function()
    local iron = require("iron.core")
    local view = require("iron.view")
    iron.setup({
      config = {
        -- REPL открывается в вертикальном сплите (40% экрана)
        repl_open_cmd = view.split.vertical.botright(0.40),
        scratch_repl = true,

        repl_definition = {
          python = {
            command = { "uv", "run", "--with", "ipython", "ipython", "--no-autoindent" },
          },
        },
      },
      highlight = {
        italic = true,
      },
      keymaps = {},
      ignore_blank_lines = true,
    })
  end,
}
