return {
	{
		"nvim-telescope/telescope.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
			{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
		},
		cmd = "Telescope",
		config = function()
			require("telescope").setup({
				defaults = {
					file_ignore_patterns = { "node_modules", ".git", "dist", "build" },
					vimgrep_arguments = {
						"rg",
						"--hidden",
						"--no-heading",
						"--with-filename",
						"--line-number",
						"--column",
						"--smart-case",
						"--trim",
					},
				},
			})
			require("telescope").load_extension("fzf")
		end,
	},
	{
		"phaazon/hop.nvim",
		branch = "v2",
		cmd = "HopWord",
		config = function()
			require("hop").setup()
		end,
	},
	{
		"lewis6991/gitsigns.nvim",
		event = "BufReadPre",
		config = function()
			require("gitsigns").setup()
		end,
	},
	{
		"akinsho/toggleterm.nvim",
		version = "*",
		cmd = { "ToggleTerm", "TermExec" },
		config = true,
	},
}
