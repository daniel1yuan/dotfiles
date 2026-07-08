return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  opts = {
    -- Renders images inline in markdown buffers. Needs a kitty graphics
    -- protocol terminal (ghostty/kitty) and ImageMagick for non-PNG formats.
    image = { enabled = true },
    indent = { enabled = true },
    notifier = { enabled = true, timeout = 5000 },
    scratch = { enabled = true },
    dashboard = {
      enabled = true,
      sections = {
        { section = "header" },
        { section = "keys", gap = 1, padding = 1 },
        { section = "recent_files", limit = 8, padding = 1 },
        { section = "startup" },
      },
    },
  },
  keys = {
    {
      "<leader>gg",
      function()
        Snacks.lazygit()
      end,
      desc = "Lazygit",
    },
    {
      "<leader>.",
      function()
        Snacks.scratch()
      end,
      desc = "Toggle scratch buffer",
    },
    {
      "<leader>>",
      function()
        Snacks.scratch.select()
      end,
      desc = "Select scratch buffer",
    },
    {
      "<leader>n",
      function()
        Snacks.notifier.show_history()
      end,
      desc = "Notification history",
    },
  },
}
