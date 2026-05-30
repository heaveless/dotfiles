return {
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		event = "BufReadPost",
		config = function()
			require("nvim-treesitter.configs").setup({
				ensure_installed = {
					"lua",
					"typescript",
					"javascript",
					"json",
					"markdown",
					"html",
					"css",
				},
				highlight = { enable = true },
				indent = { enable = true },
			})
		end,
	},
	{
		"williamboman/mason.nvim",
		cmd = "Mason",
		config = true,
	},
	{
		"williamboman/mason-lspconfig.nvim",
		dependencies = { "williamboman/mason.nvim" },
		event = "BufReadPre",
		config = function()
			require("mason-lspconfig").setup({
				ensure_installed = { "lua_ls", "ts_ls", "astro" },
				automatic_installation = true,
			})
			require("mason-lspconfig").setup_handlers({
				function(server_name)
					require("lspconfig")[server_name].setup({})
				end,
			})
		end,
	},
	{
		"neovim/nvim-lspconfig",
		event = "BufReadPre",
	},
	{
		"stevearc/conform.nvim",
		event = "BufWritePre",
		config = function()
			require("conform").setup({
				formatters_by_ft = {
					lua = { "stylua" },
					typescript = { "prettierd" },
					javascript = { "prettierd" },
					json = { "prettierd" },
					html = { "prettierd" },
					css = { "prettierd" },
				},
				format_on_save = {
					timeout_ms = 500,
					lsp_format = "fallback",
				},
			})
		end,
	},
}
