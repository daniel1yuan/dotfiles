return {
  "folke/trouble.nvim",
  cmd = "Trouble",
  keys = {
    { "<leader>xx", function() require("trouble").toggle("diagnostics") end, desc = "Diagnostics (project)" },
    { "<leader>xd", function() require("trouble").toggle({ mode = "diagnostics", filter = { buf = 0 } }) end, desc = "Diagnostics (buffer)" },
    { "<leader>xq", function() require("trouble").toggle("qflist") end, desc = "Quickfix list" },
  },
  opts = {},
}
