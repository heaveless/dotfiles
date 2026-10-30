return {
	"stevearc/conform.nvim",
	event = "BufWritePre",
	opts = {
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
	},
}
