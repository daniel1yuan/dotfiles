return {
  "nvim-tree/nvim-tree.lua",
  version = "*",
  lazy = false,
  dependencies = {
    "nvim-tree/nvim-web-devicons",
  },
  config = function()
    require("nvim-tree").setup({
      update_focused_file = {
        enable = true,
      },
      filters = {
        -- Show gitignored files (specs, drafts) dimmed; `I` in the tree re-hides them
        git_ignored = false,
        -- Always-hidden names (vim regex against basename); `U` in the tree toggles.
        -- Sibling lists: fd/ignore (file finder) and ripgrep/config (grep)
        custom = { "^\\.git$", "^node_modules$" },
      },
    })
    local nvim_api = require("nvim-tree.api")
    vim.keymap.set("n", "<leader>t", nvim_api.tree.toggle, { desc = "[T]oggle file tree" })
  end,
}
