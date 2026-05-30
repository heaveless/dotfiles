return {
	{
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
					italic = true,
					transparency = false,
				},
				highlight_groups = {
					EndOfBuffer = { fg = "base", inherit = false },
					WinSeparator = { fg = "base", bg = "base", inherit = false },
					VertSplit = { fg = "base", bg = "base", inherit = false },
				},
			})
			vim.cmd("colorscheme rose-pine")
		end,
	},
	{
		"akinsho/bufferline.nvim",
		event = "VeryLazy",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			local highlights = require("rose-pine.plugins.bufferline")
			require("bufferline").setup({
				highlights = highlights,
				options = {
					separator_style = "thin",
					show_buffer_close_icons = false,
					show_close_icon = false,
					always_show_bufferline = true,
				},
			})
		end,
	},
	{
		"nvim-tree/nvim-tree.lua",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		cmd = { "NvimTreeToggle", "NvimTreeFocus" },
		config = function()
			require("nvim-tree").setup({
				renderer = {
					root_folder_label = false,
					highlight_git = true,
					indent_markers = { enable = true },
				},
				view = {
					side = "left",
					width = 35,
				},
			})
		end,
	},
}
