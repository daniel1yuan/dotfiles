return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  opts = {
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
    { "<leader>.", function() Snacks.scratch() end, desc = "Scratch buffer" },
    { "<leader>n", function() Snacks.notifier.show_history() end, desc = "Notification history" },
  },
}
