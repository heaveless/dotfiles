return {
	{
		"kurochenko/pi.nvim",
		event = "VeryLazy",
		dependencies = {
			{ "folke/snacks.nvim", optional = true },
		},
		opts = {
			-- replaced below by a keymap that also handles focusing
			keymaps = { toggle = false },
		},
		config = function(_, opts)
			require("pi").setup(opts)

			-- One key for both directions: closed -> open, elsewhere -> focus,
			-- inside the panel -> close (buffer and pi process stay alive)
			vim.keymap.set({ "n", "t" }, "<leader>pt", function()
				local term = require("pi.terminal")
				if not term.is_open() then
					term.open({ enter = true })
				elseif vim.api.nvim_get_current_win() == term.win then
					term.close()
				else
					term.focus()
				end
			end, { desc = "Pi: open / focus / close" })

			-- Back to the previous window (your code) leaving the panel open
			vim.keymap.set({ "n", "t" }, "<C-h>", "<C-\\><C-n><C-w>p", { desc = "Pi: back to code" })
		end,
	},
}
