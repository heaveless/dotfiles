return {
	"nvim-lualine/lualine.nvim",
	event = "VeryLazy",
	opts = {
		options = { theme = "rose-pine" },
		sections = {
			lualine_a = { "mode" },
			lualine_b = { "branch" },
			lualine_c = { "filename" },
			lualine_x = { "diagnostics" },
			lualine_y = { "progress" },
			lualine_z = { "location" },
		},
		disabled_filetypes = { "snacks_terminal" },
	},
}
