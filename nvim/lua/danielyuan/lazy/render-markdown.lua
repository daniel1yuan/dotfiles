return {
  "MeanderingProgrammer/render-markdown.nvim",
  ft = { "markdown", "codecompanion" },
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "nvim-tree/nvim-web-devicons",
  },
  opts = {
    -- Complete checkboxes and callouts (> [!NOTE] etc) via blink.cmp
    completions = { blink = { enabled = true } },
    -- Requires pylatexenc, which isn't installed; silences the health warning
    latex = { enabled = false },
  },
  keys = {
    { "<leader>m", "<cmd>RenderMarkdown buf_toggle<cr>", desc = "Toggle [M]arkdown render", ft = "markdown" },
  },
}
