return {
	{
		"lewis6991/gitsigns.nvim",
		event = "BufReadPre",
		config = function()
			require("gitsigns").setup()
		end,
	},
	{
		"numToStr/Comment.nvim",
		event = "VeryLazy",
		config = true,
	},
	{
		"echasnovski/mini.pairs",
		event = "InsertEnter",
		config = true,
	},
	{
		"folke/snacks.nvim",
		lazy = false,
		priority = 1000,
		keys = {
			{ "<leader>ff", function() Snacks.picker.files() end, desc = "Find files" },
			{ "<leader>fg", function() Snacks.picker.grep() end, desc = "Live grep" },
			{ "<leader>fb", function() Snacks.picker.buffers() end, desc = "Buffers" },
			{ "<leader>fh", function() Snacks.picker.help() end, desc = "Help tags" },
			{ "<leader>fw", function() Snacks.words.jump() end, desc = "Jump word" },
			{ "<leader>?", function() Snacks.picker.keymaps() end, desc = "Keymaps" },
		},
		opts = {
			input = {},
			picker = {},
			terminal = { enabled = true },
			words = { enabled = true },
			notifier = { enabled = true },
			statuscolumn = { enabled = true },
			dashboard = { enabled = true },
		},
	},
}
