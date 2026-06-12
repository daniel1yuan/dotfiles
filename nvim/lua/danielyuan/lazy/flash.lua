return {
  "folke/flash.nvim",
  event = "VeryLazy",
  opts = {},
  keys = {
    {
      "s",
      function()
        require("flash").jump()
      end,
      mode = { "n", "x", "o" },
      desc = "Flash jump",
    },
    {
      "S",
      function()
        require("flash").treesitter()
      end,
      mode = { "n", "x", "o" },
      desc = "Flash treesitter select",
    },
    {
      "<c-s>",
      function()
        require("flash").toggle()
      end,
      mode = { "c" },
      desc = "Toggle flash search",
    },
  },
}
