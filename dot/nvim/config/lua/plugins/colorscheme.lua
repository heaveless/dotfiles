return {
	"rose-pine/neovim",
	name = "rose-pine",
	priority = 1000,
	config = function()
		require("rose-pine").setup({
			variant = "main",
			dim_inactive_windows = false,
			extend_background_behind_borders = true,
			styles = {
				bold = true,
				italic = false,
				transparency = false,
			},
			highlight_groups = {
				EndOfBuffer = { fg = "base", inherit = false },
				WinSeparator = { fg = "base", bg = "base", inherit = false },
				VertSplit = { fg = "base", bg = "base", inherit = false },
			},
		})

		vim.cmd.colorscheme("rose-pine")
	end,
}
