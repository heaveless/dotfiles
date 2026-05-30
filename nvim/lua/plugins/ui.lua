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
				sections = {
					lualine_a = { "mode" },
					lualine_b = { "branch" },
					lualine_c = { "filename" },
					lualine_x = { "diagnostics" },
					lualine_y = { "progress" },
					lualine_z = { "location" },
				},
				disabled_filetypes = { "snacks_terminal", "oil" },
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
				keymaps = {
					["-"] = false,
				},
			})
			vim.keymap.set("n", "-", function()
				require("oil").open_float(vim.fn.getcwd())
			end, { desc = "Open file explorer" })
		end,
	},
}
