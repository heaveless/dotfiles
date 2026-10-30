local shell

local terminal_opts = { win = { position = "bottom", height = 0.35 } }

local function toggle_explorer()
	local picker = Snacks.picker.get({ source = "explorer" })[1]

	if not picker then
		Snacks.explorer()
	elseif picker:is_focused() then
		picker:close()
	else
		picker:focus()
	end
end

local function jump_word()
	Snacks.words.jump()
end

local function picker(name)
	return function()
		Snacks.picker[name]()
	end
end

local function toggle_terminal()
	if shell and shell:buf_valid() then
		shell:toggle()
		return
	end

	shell = Snacks.terminal.get(nil, terminal_opts)
end

return {
	"folke/snacks.nvim",
	lazy = false,
	priority = 1000,
	keys = {
		{ "<leader>t", toggle_terminal, mode = { "n", "t" }, desc = "Toggle terminal" },
		{ "<Esc><Esc>", "<C-\\><C-n>", mode = "t", desc = "Terminal normal mode" },
		{ "-", toggle_explorer, desc = "File explorer" },
		{ "<leader>ff", picker("files"), desc = "Find files" },
		{ "<leader>fg", picker("grep"), desc = "Live grep" },
		{ "<leader>fb", picker("buffers"), desc = "Buffers" },
		{ "<leader>fh", picker("help"), desc = "Help tags" },
		{ "<leader>fw", jump_word, desc = "Jump word" },
		{ "<leader>?", picker("keymaps"), desc = "Keymaps" },
	},
	opts = {
		input = {},
		picker = {},
		explorer = { enabled = true, replace_netrw = true, trash = true },
		terminal = { enabled = true },
		words = { enabled = true },
		notifier = { enabled = true },
		statuscolumn = { enabled = true },
		dashboard = { enabled = true },
	},
}
