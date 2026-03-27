return { -- Highlight, edit, and navigate code
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  lazy = false,
  config = function()
    require("nvim-treesitter").setup({
      ensure_installed = {
        "lua",
        "typescript",
        "javascript",
        "tsx",
        "vue",
        "python",
        "rust",
        "go",
        "gomod",
        "gosum",
        "markdown",
        "markdown_inline",
        "json",
        "yaml",
        "toml",
        "html",
        "css",
        "bash",
        "vim",
        "vimdoc",
      },
      auto_install = true,
    })
  end,
}
