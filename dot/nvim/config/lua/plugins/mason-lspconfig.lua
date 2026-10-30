return {
	"williamboman/mason-lspconfig.nvim",
	event = "BufReadPre",
	dependencies = {
		"williamboman/mason.nvim",
		"neovim/nvim-lspconfig",
	},
	opts = {
		ensure_installed = { "lua_ls", "ts_ls", "astro" },
	},
}
