return { -- Highlight, edit, and navigate code
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  lazy = false,
  config = function()
    local ts = require("nvim-treesitter")

    -- Pre-install parsers for commonly used languages
    ts.install({
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

    -- Auto-install parsers for new filetypes
    vim.api.nvim_create_autocmd("FileType", {
      callback = function(args)
        if vim.bo[args.buf].buftype ~= "" then return end

        local lang = vim.treesitter.language.get_lang(args.match)
        if not lang then return end
        if pcall(vim.treesitter.start, args.buf, lang) then return end

        ts.install({ lang }):await(function(err)
          if err then return end
          vim.schedule(function()
            if vim.api.nvim_buf_is_valid(args.buf) then
              pcall(vim.treesitter.start, args.buf, lang)
            end
          end)
        end)
      end,
    })
  end,
}
