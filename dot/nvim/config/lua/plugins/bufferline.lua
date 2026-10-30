return {
	"akinsho/bufferline.nvim",
	event = "VeryLazy",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	opts = function()
		return {
			highlights = require("rose-pine.plugins.bufferline"),
			options = {
				separator_style = "thin",
				show_buffer_close_icons = false,
				show_close_icon = false,
				always_show_bufferline = true,
			},
		}
	end,
}
