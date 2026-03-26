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
    })
    local nvim_api = require("nvim-tree.api")
    vim.keymap.set("n", "<leader>t", nvim_api.tree.toggle, { desc = "[T]oggle file tree" })
  end,
}
