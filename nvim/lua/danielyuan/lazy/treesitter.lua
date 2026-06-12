return { -- Highlight, edit, and navigate code
  "nvim-treesitter/nvim-treesitter",
  -- The rewritten main branch. The old master branch is frozen; its API
  -- (ensure_installed/auto_install in setup) no longer exists. On main,
  -- parsers are installed explicitly and highlighting is started per-buffer.
  -- Requires nvim 0.11+ and the tree-sitter CLI (see packages/).
  branch = "main",
  build = ":TSUpdate",
  lazy = false,
  config = function()
    require("nvim-treesitter").install({
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
    })

    vim.api.nvim_create_autocmd("FileType", {
      group = vim.api.nvim_create_augroup("treesitter-start", { clear = true }),
      callback = function(ev)
        -- Start highlighting when a parser exists for this filetype; no-op otherwise
        pcall(vim.treesitter.start, ev.buf)
      end,
    })
  end,
}
