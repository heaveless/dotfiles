return {
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
	{
		"folke/snacks.nvim",
		keys = {
			{ "<leader>ff", function() Snacks.picker.files() end, desc = "Find files" },
			{ "<leader>fg", function() Snacks.picker.grep() end, desc = "Live grep" },
			{ "<leader>fb", function() Snacks.picker.buffers() end, desc = "Buffers" },
			{ "<leader>fh", function() Snacks.picker.help() end, desc = "Help tags" },
			{ "<leader>f", function() Snacks.words.jump() end, desc = "Jump word" },
		},
		opts = {
			input = {},
			picker = {
				actions = {
					opencode_send = function(...)
						return require("opencode").snacks_picker_send(...)
					end,
				},
				win = {
					input = {
						keys = {
							["<a-a>"] = { "opencode_send", mode = { "n", "i" } },
						},
					},
				},
				layouts = {
					default = {
						layout = { preset = "dropdown" },
					},
				},
			},
			words = {
				enabled = true,
			},
		},
	},
}
