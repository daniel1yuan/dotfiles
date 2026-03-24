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

		vim.api.nvim_create_autocmd("FileType", {
			callback = function(args)
				local buf = args.buf
				local ft = args.match

				-- Skip UI/special buffers
				if vim.bo[buf].buftype ~= "" then
					return
				end

				local lang = vim.treesitter.language.get_lang(ft)
				if not lang then
					return
				end

				-- Parser + queries already available
				if pcall(vim.treesitter.start, buf, lang) then
					return
				end

				-- Not installed — install then enable
				local task = ts.install({ lang })
				task:await(function(err)
					if err then
						return
					end
					vim.schedule(function()
						if vim.api.nvim_buf_is_valid(buf) then
							pcall(vim.treesitter.start, buf, lang)
						end
					end)
				end)
			end,
		})
	end,
}
