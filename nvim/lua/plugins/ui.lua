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
					italic = false,
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
		"nvim-lualine/lualine.nvim",
		event = "VeryLazy",
		config = function()
			require("lualine").setup({
				options = { theme = "rose-pine" },
			})
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
		"stevearc/oil.nvim",
		lazy = false,
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			require("oil").setup({
				view_options = {
					show_hidden = true,
				},
			})
			vim.keymap.set("n", "-", "<cmd>Oil<CR>", { desc = "Open file explorer" })
		end,
	},
}
