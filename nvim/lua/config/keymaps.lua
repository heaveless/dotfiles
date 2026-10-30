-- Single pinned shell: keeps snacks from re-spawning a shell (its internal cache
-- is a weak table, so a collected entry means a brand new terminal + job).
local shell
local term_opts = { win = { position = "bottom", height = 0.35 } }

vim.keymap.set({ "n", "t" }, "<leader>t", function()
	if shell and shell:buf_valid() then
		shell:toggle()
		return
	end
	-- Creates, shows and starts the job on first use
	shell = Snacks.terminal.get(nil, term_opts)
end, { desc = "Toggle terminal" })

vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Terminal normal mode" })
