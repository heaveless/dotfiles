local M = {
	"nvim-tree/nvim-tree.lua",
	dependencies = {
		{ "nvim-tree/nvim-web-devicons" }
	},
	cmd = { "NvimTreeToggle", "NvimTreeFocus" }
}

M.init = function()
	vim.keymap.set("n", "<C-n>", "<cmd> NvimTreeToggle <CR>")
	vim.keymap.set("n", "<leader>e", "<cmd> NvimTreeFocus <CR>")
end

M.config = function(_, opts)
	require("nvim-tree").setup()
end

return M
