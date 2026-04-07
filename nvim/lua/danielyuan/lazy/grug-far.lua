return {
  "MagicDuck/grug-far.nvim",
  keys = {
    { "<leader>sr", function() require("grug-far").open() end, desc = "Search and replace (project)" },
    {
      "<leader>sr",
      function()
        require("grug-far").with_visual_selection()
      end,
      mode = "v",
      desc = "Search and replace (selection)",
    },
  },
  opts = {},
}
