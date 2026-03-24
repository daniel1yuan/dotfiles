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
				cmp = true,
				gitsigns = true,
				nvimtree = true,
				treesitter = true,
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
