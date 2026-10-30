vim.keymap.set({ "n", "t" }, "<leader>t", function()
	Snacks.terminal.toggle(nil, { win = { position = "bottom", height = 0.35 } })
end, { desc = "Toggle terminal" })

vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Terminal normal mode" })
