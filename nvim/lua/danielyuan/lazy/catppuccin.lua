function SetColors(color)
  color = color or "catppuccin-mocha"
  vim.cmd.colorscheme(color)
end

return {
  "catppuccin/nvim",
  name = "catppuccin",
  priority = 1000,
  config = function()
    require("catppuccin").setup({
      integrations = {
        blink_cmp = true,
        diffview = true,
        gitsigns = true,
        nvimtree = true,
        treesitter = true,
        snacks = true,
        trouble = true,
        notify = false,
        mini = {
          enabled = true,
          indentscope_color = "",
        },
      },
    })

    SetColors("catppuccin-mocha")
  end,
}
