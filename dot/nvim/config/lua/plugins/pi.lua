local function toggle()
	local terminal = require("pi.terminal")

	if not terminal.is_open() then
		terminal.open({ enter = true })
	elseif vim.api.nvim_get_current_win() == terminal.win then
		terminal.close()
	else
		terminal.focus()
	end
end

return {
	"kurochenko/pi.nvim",
	event = "VeryLazy",
	dependencies = {
		{ "folke/snacks.nvim", optional = true },
	},
	opts = {
		keymaps = { toggle = false },
	},
	config = function(_, opts)
		require("pi").setup(opts)

		vim.keymap.set({ "n", "t" }, "<leader>pt", toggle, { desc = "Pi: open / focus / close" })
		vim.keymap.set({ "n", "t" }, "<C-h>", "<C-\\><C-n><C-w>p", { desc = "Pi: back to code" })
	end,
}
