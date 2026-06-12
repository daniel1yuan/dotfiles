return {
  "pmizio/typescript-tools.nvim",
  -- TS server runs on node; skip entirely when no node runtime is installed
  enabled = function()
    return vim.fn.executable("node") == 1
  end,
  dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
  opts = {},
  config = function()
    require("typescript-tools").setup({})
  end,
}
