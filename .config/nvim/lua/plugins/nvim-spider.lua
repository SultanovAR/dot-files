return {
  "chrisgrieser/nvim-spider",
  opts = {},
  keys = {
    {
      "w",
      function()
        require("spider").motion("w")
      end,
      mode = { "n", "o", "x" },
      desc = "Spider: next word start",
    },
    {
      "e",
      function()
        require("spider").motion("e")
      end,
      mode = { "n", "o", "x" },
      desc = "Spider: word end",
    },
    {
      "b",
      function()
        require("spider").motion("b")
      end,
      mode = { "n", "o", "x" },
      desc = "Spider: previous word start",
    },
  },
}
