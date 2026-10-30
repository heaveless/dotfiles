return {
	"benlubas/molten-nvim",
	dependencies = { "3rd/image.nvim" },
	build = ":UpdateRemotePlugins",
	ft = { "markdown", "python", "quarto" },
	init = function()
		vim.g.python3_host_prog = vim.fn.expand("~/.local/share/nvim/molten-venv/bin/python3")

		vim.g.molten_image_provider = "image.nvim"
		vim.g.molten_image_location = "both"
		vim.g.molten_auto_open_output = false
		vim.g.molten_output_win_style = "minimal"
		vim.g.molten_output_win_border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" }
		vim.g.molten_output_win_cover_gutter = true
		vim.g.molten_use_border_highlights = true
		vim.g.molten_output_virt_lines = true
		vim.g.molten_virt_text_output = true
		vim.g.molten_virt_text_max_lines = 50
		vim.g.molten_wrap_output = true
		vim.g.molten_cover_empty_lines = true
	end,
	config = function()
		require("molten.keymaps").setup()
	end,
}
